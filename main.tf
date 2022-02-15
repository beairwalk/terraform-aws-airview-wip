# ----------------------------------------------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = local.region
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE SOME LOCAL VARIABLES 
# ----------------------------------------------------------------------------------------------------------------------

locals {
  name                              = "airview-dev-env"
  region                            = "us-east-1"
  build_directory_path              = "${path.module}/template/build"
  lambda_common_libs_layer_path     = "${path.module}/template/nodejs"
  lambda_common_libs_layer_zip_name = "${local.build_directory_path}/function1.zip"
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE YOUR REMOTE STATE
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket = "airview-dev-terraform-remote-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# GENERATE RANDOM PASSWORD FOR THE RDS DATABASE
# ----------------------------------------------------------------------------------------------------------------------

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "_%"
}

# ----------------------------------------------------------------------------------------------------------------------
# GENERATE KMS ENCRYPTION KEY
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "airveiw_kms_key" {
  description             = "KMS key is used to encrypt bucket objects and other infrastructures"
  deletion_window_in_days = 7
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A SECRET MANAGER FOR STORING THE DATABASE PASSWORDS
# ----------------------------------------------------------------------------------------------------------------------

module "airview_secrets_manager" {
  source             = "./modules/secrets_manager"
  secret_name        = ["airview_rds_master_password"]
  secret_description = "Master password for Airview RDS"
  secret_string      = random_password.this.result
  kms_key_id         = aws_kms_key.airveiw_kms_key.arn
  tags               = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE AN RDS DATABASE CLUSTER
# ----------------------------------------------------------------------------------------------------------------------

module "airview_rds_cluster" {
  source = "./modules/rds_cluster"

  name                         = "${local.name}-rds-cluster"
  master_username              = "aws_admin"
  master_password              = random_password.this.result
  port                         = 3306
  backup_retention_period      = "7"
  preferred_maintenance_window = "Sun:22:00-Sun:22:30"
  preferred_backup_window      = "07:00-07:30"
  storage_encrypted            = true
  copy_tags_to_snapshot        = true
  engine                       = "aurora-mysql"
  instance_type                = "db.t3.medium"
  kms_key_id                   = aws_kms_key.airveiw_kms_key.arn

  tags           = var.tags
  enabled        = true
  cluster_family = "aurora-mysql5.7"
  cluster_parameters = [
    {
      name         = "max_connections"
      value        = "500"
      apply_method = "pending-reboot"
    }
  ]
}


# ----------------------------------------------------------------------------------------------------------------------
# CREATE AN S3 BUCKET
# ----------------------------------------------------------------------------------------------------------------------

module "airview_awssb22src_bucket" {
  source = "./modules/s3"

  bucket_names       = ["awssb22src2022"]
  acl                = "private"
  versioning_enabled = true
  force_destroy      = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.airveiw_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = var.tags
}

module "airview_airviewtest_bucket" {
  source = "./modules/s3"

  bucket_names       = ["airviewtest2022"]
  acl                = "public-read"
  versioning_enabled = true
  force_destroy      = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.airveiw_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "cdn_policy" {
  bucket = module.airview_airviewtest_bucket.s3_bucket_name_id[0]
  policy = data.aws_iam_policy_document.origin.json
}

# Adds cloudfront and codebuild permission to the S3 bucket
data "aws_iam_policy_document" "origin" {

  statement {
    sid       = "S3GetObjectForCloudFront"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${module.airview_airviewtest_bucket.s3_bucket_name_id[0]}/*"]
    principals {
      type        = "AWS"
      identifiers = ["${module.airview_cloudfront.cloudfront_origin_access_arn}"]
    }
  }

  statement {
    sid       = "S3ListBucketForCloudFront"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${module.airview_airviewtest_bucket.s3_bucket_name_id[0]}"]
    principals {
      type        = "AWS"
      identifiers = ["${module.airview_cloudfront.cloudfront_origin_access_arn}"]
    }
  }

  statement {
    sid       = "S3FullforCodebuild"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${module.airview_airviewtest_bucket.s3_bucket_name_id[0]}"]
    principals {
      type        = "AWS"
      identifiers = ["${module.codebuild_role.iam_role_arn}"]
    }
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE CLOUDFRONT FOR THE APPLICATION
# USE THE DATA VARIABLES TO : 
# FETCH AWS MANAGED CACHE POLICY
# FETCH AWS CLOUDFRONT ORIGIN REQUEST POLICY
# ----------------------------------------------------------------------------------------------------------------------

data "aws_cloudfront_cache_policy" "policy" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "policy" {
  name = "Managed-CORS-S3Origin"
}

module "airview_cloudfront" {
  source              = "./modules/cloudfront"
  s3_bucket_names     = ["${module.airview_airviewtest_bucket.s3_bucket_name_id[0]}"]
  lambda_arn          = module.lambda-edge.lambda_function_arn
  region              = "us-east-1"
  comment             = "Airview CloudFront created with Terraform"
  price_class         = "PriceClass_200"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  s3_origin_configs = [{
    domain_name            = module.airview_airviewtest_bucket.s3_domain[0]
    origin_id              = module.airview_airviewtest_bucket.s3_domain[0]
    origin_access_identity = module.airview_cloudfront.cloudfront_access_identity_path
    }
  ]

  default_cache_behavior = {
    target_origin_id         = module.airview_airviewtest_bucket.s3_domain[0]
    viewer_protocol_policy   = "allow-all"
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.policy.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.policy.id
    compress                 = true
    viewer_protocol_policy   = "redirect-to-https"

    lambda_function_association = {
      viewer-request = {
        event_type   = "viewer-request"
        lambda_arn   = module.lambda-edge.lambda_function_arn
        include_body = false
      }
    }
  }

  custom_error_response = [
    {
      "error_caching_min_ttl" = 0,
      "error_code"            = 403,
      "response_code"         = 200,
      "response_page_path"    = "/index.html",
    },
    {
      "error_caching_min_ttl" = 0,
      "error_code"            = 404,
      "response_code"         = 200,
      "response_page_path"    = "/index.html",
    },
  ]

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["US", "CA", "GB", "DE"]
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  tags = var.tags

}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE THE LAMBDA FUNCTION
# USE THE DATA VARIABLES TO : 
# CREATE A ROLE FOR THE LAMBDA EDGE FUNCTION
# CREATE A ZIP ARCHIVE FROM SOURCES
# ADD COGNITO VALUES TO INDEX FILE USING TEMPLATE
# ATTACH SOME DEFAULT POLICICES TO THE LAMBDA EDGE ROLE
# CREATE THE INDEX.JS FILE FROM THE TEMPLATE
# INSTALL THE NPM MODULE 
# CREATE A LAMBDA LAYER VERSION
# UPLOAD THE ZIP FILE TO S3 BUCKET
# ----------------------------------------------------------------------------------------------------------------------

data "template_file" "lambda_role_policy" {
  template = file("${path.module}/policy/lambda_edge_policy.json.tpl")
}

module "lambda_edge_role" {
  source             = "./modules/iam"
  create_role        = true
  role_name          = "${local.name}-lambda-edge-role"
  role_description   = "Role which is used by Lambda"
  assume_role_policy = data.template_file.lambda_role_policy.rendered
}

data "archive_file" "airview_lambda_common_libs_layer_package" {
  type        = "zip"
  source_dir  = local.lambda_common_libs_layer_path
  output_path = local.lambda_common_libs_layer_zip_name
  depends_on  = [null_resource.airview_lambda_nodejs_layer]
}

data "template_file" "lambda_template" {
  template = file("${path.module}/template/index.js.tpl")
  vars = {
    poolId     = module.aws_cognito_airview_user_pool.user_pool_id
    appId      = module.aws_cognito_airview_user_pool.client_ids
    poolDomain = "airviewtest.auth.us-east-1.amazoncognito.com"
  }
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       = module.lambda_edge_role.iam_role_name
  count      = length(var.iam_policy_arn)
  policy_arn = var.iam_policy_arn[count.index]
}

resource "local_file" "lambda_handler" {
  filename = "${local.lambda_common_libs_layer_path}/index.js"
  content  = data.template_file.lambda_template.rendered
}

resource "null_resource" "airview_lambda_nodejs_layer" {
  depends_on = [local_file.lambda_handler]
  provisioner "local-exec" {
    working_dir = "${local.lambda_common_libs_layer_path}/"
    command     = "npm install cognito-at-edge"
  }

  triggers = {
    rerun_every_time = "${uuid()}"
  }
}

resource "aws_lambda_layer_version" "airview_lambda_nodejs_layer" {
  layer_name          = "commonLibs"
  filename            = local.lambda_common_libs_layer_zip_name
  source_code_hash    = data.archive_file.airview_lambda_common_libs_layer_package.output_base64sha256
  compatible_runtimes = ["nodejs12.x"]
}

resource "aws_s3_bucket_object" "function" {
  bucket = module.airview_awssb22src_bucket.s3_bucket_name_id[0]
  key    = "function.zip"
  source = data.archive_file.airview_lambda_common_libs_layer_package.output_path
  depends_on = [
    module.airview_awssb22src_bucket
  ]
}

module "lambda-edge" {
  source = "./modules/lambda"

  lambda_name = "${local.name}-mylambda"
  description = "${local.name} - Lambda Function."

  lambda_at_edge   = true
  runtime          = "nodejs12.x"
  handler_name     = "handler"
  timeout          = 5
  publish          = true
  source_code_hash = filebase64sha256(local.lambda_common_libs_layer_zip_name)

  lambda_zip_path = local.lambda_common_libs_layer_zip_name
  lambda_role     = module.lambda_edge_role.iam_role_arn

  # ATTACH A MAP OF PERMISSIONS TO THE LAMBDA FUNCTION
  source_arn           = module.api_gateway.aws_api_gateway_execution_arn
  lambda_function_name = module.lambda-edge.lambda_function_name
  statement_id         = "AllowExecutionFromAPIGateway"
  action               = "lambda:InvokeFunction"
  principal            = "apigateway.amazonaws.com"

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CODEBUILD
# CREATE A ROLE FOR THE CODEBUILD AND ATTACH A POLICY TO IT
# ----------------------------------------------------------------------------------------------------------------------

data "template_file" "codebuild_policy" {
  template = file("${path.module}/policy/codebuild_policy.json.tpl")
  vars = {
    bucket_arn = module.airview_awssb22src_bucket.s3_codebuild_bucket_arn[0]
  }
}

module "codebuild_role" {
  source           = "./modules/iam"
  create_role      = true
  role_name        = "${local.name}-codebuild-role"
  role_description = "Role which is used by codebuild to build the artifacts"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  create_role_policy = true
  role_policy_name   = "codebuild_policy"
  role_policy        = data.template_file.codebuild_policy.rendered
}

module "airview_codebuild" {
  source        = "./modules/codebuild"
  project_name  = "${local.name}-codebuild"
  build_timeout = 60
  iam_role      = module.codebuild_role.iam_role_arn
  build_bucket  = module.airview_awssb22src_bucket.s3_bucket_name_id[0]

  # Environment
  environment = {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    # Environment variables
    variables = [
      {
        name  = "appName"
        value = "airview-stg"
      },
      {
        name  = "REACT_APP_AUTH_AUTHORITY"
        value = "https://login.microsoftonline.com/xxxxxxxxxxxxxxx/v2.0/.well-known/openid-configuration"
      },
      {
        name  = "REACT_APP_AUTH_CLIENT_ID"
        value = "xxxxxxxxxxxxxxxxxxxxxx"
      },
      {
        name  = "REACT_APP_AUTH_SCOPE"
        value = "api://airview-api-stg/.default"
      },
      {
        name  = "REACT_APP_API_HOST"
        value = "https://apim-airview-stg.azure-api.net"
      },
      {
        name  = "REACT_APP_GITHUB_CLIENT_ID"
        value = "xxxxxxxxxxxxxxxxxxxxxx"
      },
      {
        name  = "REACT_APP_GIT_CALLBACK_URL"
        value = "https://d2kgfi0pf250xd.cloudfront.net/github/authorizing"
      },
      {
        name  = "REACT_APP_ADO_CLIENT_ID"
        value = "xxxxxxxxxxxxxxxxxxxxxx"
      },
      {
        name  = "REACT_APP_AUTH_REDIRECT_URI"
        value = "https://d2kgfi0pf250xd.cloudfront.net/signin-callback"
      },
      {
        name  = "remoteRepoRef"
        value = "main"
      },
      {
        name  = "remoteRepoUrl"
        value = "https://github.com/AirWalk-Digital/airview-frontend.git"
      }
    ]
  }

  # Artifacts
  artifacts = {
    location       = module.airview_airviewtest_bucket.s3_bucket_name_id[0]
    type           = "S3"
    path           = "/"
    packaging      = "NONE"
    namespace_type = "BUILD_ID"
  }

  # Source
  codebuild_source_version = "master"
  codebuild_source = {
    type            = "GITHUB"
    location        = #SOURCE GITHUB URL
    git_clone_depth = 1

    git_submodules_config = {
      fetch_submodules = true
    }
  }

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# CODEPIPELINE 
# CREATE A ROLE FOR THE CODEPIPELINE AND ATTACH A POLICY TO IT
# ----------------------------------------------------------------------------------------------------------------------

data "template_file" "codepipeline_policy" {
  template = file("${path.module}/policy/codepipeline_policy.json.tpl")
  vars = {
    bucket_arn              = module.airview_awssb22src_bucket.s3_codebuild_bucket_arn[0]
    codestar_connection_arn = module.airview_aws_codepipeline.codestar_connection_arn
  }
}


module "codepipeline_role" {
  source           = "./modules/iam"
  create_role      = true
  role_name        = "${local.name}-codepipeline-role"
  role_description = "Role which is used by codepipeline."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  create_role_policy = true
  role_policy_name   = "codebpipeline_policy"
  role_policy        = data.template_file.codepipeline_policy.rendered
}


module "airview_aws_codepipeline" {
  source = "./modules/codepipeline"

  codepipeline_project_name = "${local.name}-codepipeline"
  codepipeline_role         = module.codepipeline_role.iam_role_arn

  s3_artifact_bucket      = module.airview_awssb22src_bucket.s3_bucket_name_id[0]
  codestar_connection_arn = module.airview_aws_codepipeline.codestar_connection_arn

  repository_name = "satyashilD/codedeploy1"
  branch          = "master"
  projectname     = module.airview_codebuild.id

  codestar_connection_name = "${local.name}-codestar"
  provider_type            = "GitHub"

  webhook_enabled           = false
  codepipeline_webhook_name = ""
  github_organization       = ""
  webhook_url               = ""
}

# ----------------------------------------------------------------------------------------------------------------------
# COGNITO
# ----------------------------------------------------------------------------------------------------------------------

module "aws_cognito_airview_user_pool" {
  source         = "./modules/cognito"
  user_pool_name = "${local.name}-mypool"

  # clients
  clients = [
    {
      name = "client"
    }
  ]

  tags = var.tags
}

# ----------------------------------------------------------------------------------------------------------------------
# API GATEWAY
# ----------------------------------------------------------------------------------------------------------------------

module "api_gateway" {
  source                = "./modules/api_gateway"
  name                  = "${local.name}-api-gateway"
  method                = "GET"
  lambda_function_arn   = module.lambda-edge.lambda_invoke_arn
  cognito_user_pool_arn = [module.aws_cognito_airview_user_pool.arn]
}






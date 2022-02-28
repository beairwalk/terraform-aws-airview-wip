provider "github" {
  token    = var.github_token != "" ? var.github_token : null
  owner    = var.github_organization
  base_url = var.github_base_url
}

# A shared secret between GitHub and AWS that allows AWS
# CodePipeline to authenticate the request came from GitHub.
# Would probably be better to pull this from the environment
# or something like SSM Parameter Store.
locals {
  webhook_secret = var.webhook_secret
  webhook_url    = join("", aws_codepipeline_webhook.airview_codepipeline_webhook.*.url)
}

resource "aws_codepipeline" "airview_codepipeline" {
  name     = var.codepipeline_project_name
  role_arn = var.codepipeline_role

  artifact_store {
    location = var.s3_artifact_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = var.repository_name
        BranchName       = var.branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.projectname
      }
    }
  }
}

resource "aws_codestarconnections_connection" "airview_codestarconnections_connection" {
  name          = var.codestar_connection_name
  provider_type = var.provider_type
}

resource "aws_codepipeline_webhook" "airview_codepipeline_webhook" {
  count           = var.webhook_enabled ? 1 : 0
  name            = var.codepipeline_webhook_name
  authentication  = var.webhook_authentication
  target_action   = var.webhook_target_action
  target_pipeline = join("", aws_codepipeline.airview_codepipeline.*.name)

  authentication_configuration {
    secret_token = local.webhook_secret
  }

  filter {
    json_path    = var.webhook_filter_json_path
    match_equals = var.webhook_filter_match_equals
  }
}

resource "github_repository_webhook" "default" {
  count = length(var.github_repositories) > 0 ? length(var.github_repositories) : 0

  repository = var.github_repositories[count.index]
  active     = var.active

  configuration {
    url          = var.webhook_url
    content_type = var.webhook_content_type
    secret       = var.webhook_secret
    insecure_ssl = var.webhook_insecure_ssl
  }

  events = var.events

  lifecycle {
    ignore_changes = [configuration[0].secret]
  }
}

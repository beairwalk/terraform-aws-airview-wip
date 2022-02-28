resource "aws_api_gateway_rest_api" "airview_api_gateway_rest_api" {
  name                     = var.name
  description              = "${var.name} API Gateway Integration Terraform Managed."
  binary_media_types       = var.binary_media_types
  minimum_compression_size = var.minimum_compression_size
  api_key_source           = var.api_key_source

  endpoint_configuration {
    types = var.types
  }
}

resource "aws_api_gateway_resource" "airview_api_gateway_resource" {
  parent_id   = aws_api_gateway_rest_api.airview_api_gateway_rest_api.root_resource_id
  path_part   = "path"
  rest_api_id = aws_api_gateway_rest_api.airview_api_gateway_rest_api.id
}

resource "aws_api_gateway_method" "airview_api_gateway_method" {
  resource_id   = aws_api_gateway_resource.airview_api_gateway_resource.id
  rest_api_id   = aws_api_gateway_rest_api.airview_api_gateway_rest_api.id
  http_method   = var.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "airview_api_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.airview_api_gateway_rest_api.id
  resource_id             = aws_api_gateway_resource.airview_api_gateway_resource.id
  http_method             = aws_api_gateway_method.airview_api_gateway_method.http_method
  uri                     = var.lambda_function_arn
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "airview_api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.airview_api_gateway_rest_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.airview_api_gateway_resource.id,
      aws_api_gateway_method.airview_api_gateway_method.id,
      aws_api_gateway_integration.airview_api_gateway_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "airview_api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.airview_api_gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.airview_api_gateway_rest_api.id
  stage_name    = "airview_api_gateway_stage"
}

resource "aws_api_gateway_authorizer" "airview_api_gateway_authorizer" {
  name            = var.name
  identity_source = var.identity_source
  rest_api_id     = aws_api_gateway_rest_api.airview_api_gateway_rest_api.id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = var.cognito_user_pool_arn
}

resource "aws_cloudwatch_log_group" "airview_cloudwatch_log_group" {
  name_prefix       = var.name
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}

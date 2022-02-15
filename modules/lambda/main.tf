resource "aws_lambda_function" "this" {

  filename                       = var.lambda_zip_path
  function_name                  = var.lambda_name
  description                    = var.description
  role                           = var.lambda_role
  handler                        = var.handler_name
  runtime                        = var.runtime
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers                         = var.layers
  publish                        = var.lambda_at_edge ? true : var.publish
  kms_key_arn                    = var.kms_key_arn
  image_uri                      = var.image_uri
  package_type                   = var.package_type
  architectures                  = var.architectures
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  source_code_hash               = var.source_code_hash


  dynamic "image_config" {
    for_each = length(var.image_config_entry_point) > 0 || length(var.image_config_command) > 0 || var.image_config_working_directory != null ? [true] : []
    content {
      entry_point       = var.image_config_entry_point
      command           = var.image_config_command
      working_directory = var.image_config_working_directory
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn == null ? [] : [true]
    content {
      target_arn = var.dead_letter_target_arn
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_mode == null ? [] : [true]
    content {
      mode = var.tracing_mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }

  dynamic "file_system_config" {
    for_each = var.file_system_arn != null && var.file_system_local_mount_path != null ? [true] : []
    content {
      local_mount_path = var.file_system_local_mount_path
      arn              = var.file_system_arn
    }
  }

  tags = var.tags
}

resource "aws_lambda_function_event_invoke_config" "this" {
  function_name                = aws_lambda_function.this.function_name
  qualifier                    = aws_lambda_function.this.version
  maximum_event_age_in_seconds = var.event_age_in_seconds
  maximum_retry_attempts       = var.retry_attempts

  depends_on = [
    aws_lambda_function.this
  ]
}

resource "aws_lambda_function_event_invoke_config" "latest" {
  function_name                = aws_lambda_function.this.function_name
  qualifier                    = "$LATEST"
  maximum_event_age_in_seconds = var.event_age_in_seconds
  maximum_retry_attempts       = var.retry_attempts

  depends_on = [
    aws_lambda_function.this
  ]
}

resource "aws_lambda_permission" "apigw_lambda" {
  action             = var.action
  event_source_token = var.event_source_token
  function_name      = var.lambda_function_name
  principal          = var.principal
  qualifier          = var.qualifier
  statement_id       = var.statement_id
  source_account     = var.source_account
  source_arn         = var.source_arn
}

resource "aws_cloudwatch_log_group" "this" {
  name              = format("/aws/lambda/%s", var.lambda_name)
  retention_in_days = var.log_retention

  tags = var.tags
}




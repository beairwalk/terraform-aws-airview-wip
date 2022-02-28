output "lambda_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = aws_lambda_function.airview_lambda_function.invoke_arn
}

output "lambda_function_arn" {
  description = "The ARN identifying your Lambda Function Version"
  value       = aws_lambda_function.airview_lambda_function.qualified_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = aws_lambda_function.airview_lambda_function.function_name
}

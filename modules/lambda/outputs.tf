output "lambda_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = aws_lambda_function.this.invoke_arn
}

output "lambda_function_arn" {
  description = "The ARN identifying your Lambda Function Version"
  value       = aws_lambda_function.this.qualified_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = aws_lambda_function.this.function_name
}


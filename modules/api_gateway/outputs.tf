output "aws_api_gateway_execution_arn" {
  description = "The Execution ARN of the REST API."
  value       = aws_api_gateway_rest_api.airview_api_gateway_rest_api.execution_arn
}

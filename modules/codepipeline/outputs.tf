output "codestar_connection_arn" {
  description = "The ARN of the CodeBuild project"
  value       = aws_codestarconnections_connection.airview_codestarconnections_connection.arn
}

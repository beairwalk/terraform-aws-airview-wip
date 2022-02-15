output "codestar_connection_arn" {
  description = "The ARN of the CodeBuild project"
  value       = aws_codestarconnections_connection.this.arn
}

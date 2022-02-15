
output "arn" {
  description = "The ARN of the CodeBuild project"
  value       = aws_codebuild_project.this.id
}

output "id" {
  description = " The name (if imported via name) or ARN (if created via Terraform or imported via ARN) of the CodeBuild project."
  value       = aws_codebuild_project.this.name
}

output "name" {
  description = "The name of the CodeBuild project"
  value       = aws_codebuild_project.this.name
}

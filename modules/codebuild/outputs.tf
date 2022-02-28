
output "arn" {
  description = "The ARN of the CodeBuild project"
  value       = aws_codebuild_project.airview_codebuild_project.id
}

output "id" {
  description = " The name (if imported via name) or ARN (if created via Terraform or imported via ARN) of the CodeBuild project."
  value       = aws_codebuild_project.airview_codebuild_project.name
}

output "name" {
  description = "The name of the CodeBuild project"
  value       = aws_codebuild_project.airview_codebuild_project.name
}

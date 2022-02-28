output "secret_arn" {
  description = "ARN of the secret"
  value       = aws_secretsmanager_secret.airview_secretsmanager_secret.*.arn
}

output "secret_id" {
  description = "ID of the secret"
  value       = aws_secretsmanager_secret.airview_secretsmanager_secret.*.id
}

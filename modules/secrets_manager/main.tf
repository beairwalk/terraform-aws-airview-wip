resource "aws_secretsmanager_secret" "airview_secretsmanager_secret" {
  count = length(var.secret_name)

  name                    = element(var.secret_name, count.index)
  description             = var.secret_description
  kms_key_id              = var.kms_key_id
  policy                  = var.policy
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "airview_secretsmanager_secret_version" {
  count = length(var.secret_name)

  secret_id     = aws_secretsmanager_secret.airview_secretsmanager_secret[count.index].id
  secret_string = var.secret_string
}

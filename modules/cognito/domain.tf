resource "aws_cognito_user_pool_domain" "domain" {
  domain          = "airview-auth"
  certificate_arn = var.domain_certificate_arn
  user_pool_id    = aws_cognito_user_pool.airview_cognito_user_pool.id
}

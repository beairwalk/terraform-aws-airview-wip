resource "aws_cognito_identity_provider" "airview_cognito_identity_provider" {
  count         = length(var.identity_providers)
  user_pool_id  = aws_cognito_user_pool.airview_cognito_user_pool.id
  provider_name = lookup(element(var.identity_providers, count.index), "provider_name")
  provider_type = lookup(element(var.identity_providers, count.index), "provider_type")

  # Optional arguments
  attribute_mapping = lookup(element(var.identity_providers, count.index), "attribute_mapping", {})
  idp_identifiers   = lookup(element(var.identity_providers, count.index), "idp_identifiers", [])
  provider_details  = lookup(element(var.identity_providers, count.index), "provider_details", {})
}

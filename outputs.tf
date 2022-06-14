output "s3_domain" {
  value = module.airview_bucket.s3_domain
}

output "s3_bucket_name_id" {
  value = module.airview_bucket.s3_bucket_name_id
}

output "s3_website_domain" {
  value = module.airview_bucket.s3_website_domain[0]
}

output "client_id" {
  value = module.aws_cognito_airview_user_pool.client_ids
}

output "lambda_edge_role" {
  value = module.lambda_edge_role.iam_role_name
}

output "name" {
  value = module.airview_bucket.s3_bucket_name_id
}

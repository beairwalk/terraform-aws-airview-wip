
output "cloudfront_origin_access_arn" {
  description = "The IAM arns of the origin access identities created"
  value       = aws_cloudfront_origin_access_identity.airview_cloudfront_origin_access_identity.iam_arn
}

output "cloudfront_access_identity_path" {
  description = "cloudfront_access_identity_path"
  value       = aws_cloudfront_origin_access_identity.airview_cloudfront_origin_access_identity.cloudfront_access_identity_path
}

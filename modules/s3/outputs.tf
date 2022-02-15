output "s3_website_domain" {
  value = aws_s3_bucket.airview-project-buckets.*.website_endpoint
}

output "s3_domain" {
  value = aws_s3_bucket.airview-project-buckets.*.bucket_regional_domain_name
}

output "s3_bucket_name_id" {
  value = aws_s3_bucket.airview-project-buckets.*.id
}

output "s3_codebuild_bucket_arn" {
  value = aws_s3_bucket.airview-project-buckets.*.arn
}


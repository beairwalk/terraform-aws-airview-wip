variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default = {
    "CostReference" = "airview-aws-project"
    "Environment"   = "dev"
  }
}

# Define policy ARNs as list
variable "iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
  ]
}

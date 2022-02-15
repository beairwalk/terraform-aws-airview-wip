output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = element(concat(aws_iam_role.this.*.arn, [""]), 0)
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = element(concat(aws_iam_role.this.*.name, [""]), 0)
}

output "iam_role_path" {
  description = "Path of IAM role"
  value       = element(concat(aws_iam_role.this.*.path, [""]), 0)
}

output "iam_instance_profile_arn" {
  description = "ARN of IAM instance profile"
  value       = element(concat(aws_iam_instance_profile.this.*.arn, [""]), 0)
}

output "iam_instance_profile_name" {
  description = "Name of IAM instance profile"
  value       = element(concat(aws_iam_instance_profile.this.*.name, [""]), 0)
}

output "iam_instance_profile_path" {
  description = "Path of IAM instance profile"
  value       = element(concat(aws_iam_instance_profile.this.*.path, [""]), 0)
}

output "iam_policy_arn" {
  description = "Managed policy ARN"
  value       = element(concat(aws_iam_policy.this.*.arn, [""]), 0)
}

output "iam_policy_id" {
  description = "Managed policy id"
  value       = element(concat(aws_iam_policy.this.*.id, [""]), 0)
}

output "iam_policy_name" {
  description = "Managed policy name"
  value       = element(concat(aws_iam_policy.this.*.name, [""]), 0)
}

output "iam_policy_path" {
  description = "Managed policy path"
  value       = element(concat(aws_iam_policy.this.*.path, [""]), 0)
}

output "iam_linked_role_arn" {
  description = "Service linked role arn"
  value       = element(concat(aws_iam_service_linked_role.this.*.arn, [""]), 0)
}

output "iam_linked_role_id" {
  description = "Service linked role id"
  value       = element(concat(aws_iam_service_linked_role.this.*.id, [""]), 0)
}

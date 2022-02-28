variable "rotation_rules" {
  description = "Whether or not to enable rotation"
  type        = bool
  default     = false
}

variable "rotation_days" {
  description = "Number of days until secret is rotated"
  type        = number
  default     = 0
}

variable "secret_name" {
  description = "Friendly name of the secret"
  type        = list(string)
  default     = []
}

variable "secret_description" {
  description = "Description of the secret"
  type        = string
  default     = null
}

variable "secret_string" {
  description = "Secret String"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS key"
  type        = string
  default     = null
}

variable "policy" {
  description = "Policy to assign to secret"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that secrets manager waits before deleting the secret"
  type        = string
  default     = null
}

variable "rotation_lambda_arn" {
  description = "Specifies the ARN of the Lambda function that can rotate the secret"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to assign to secret"
  type        = map(string)
  default     = {}
}

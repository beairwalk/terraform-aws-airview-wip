variable "create_role" {
  description = "Whether to create a role"
  type        = bool
  default     = false
}

variable "create_policy" {
  description = "Whether to create managed policy"
  type        = bool
  default     = false
}

variable "create_role_policy" {
  description = "Whether to create a inline policy"
  type        = bool
  default     = false
}

variable "create_role_policy_attachment" {
  description = "Whether to create a policy attachment"
  type        = bool
  default     = false
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile"
  type        = bool
  default     = false
}

variable "role_name" {
  description = "IAM role name"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "A map of tags to add to IAM role resources"
  type        = map(string)
  default     = {}
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "Policy to assume"
  type        = string
  default     = null
}

variable "role_permissions_boundary_arn" {
  description = "ARN of the policy that is used to set the permissions boundary"
  type        = string
  default     = null
}

variable "role_policy_name" {
  description = "Name of policy"
  type        = string
  default     = null
}

variable "role_policy" {
  description = "Inline policy for role"
  type        = string
  default     = null
}

variable "role_attachment" {
  description = "Role to attach policy to"
  type        = string
  default     = null
}

variable "policy_arn" {
  description = "Policy ARN to attach to role"
  type        = list(string)
  default     = []
}

variable "policy" {
  description = "IAM managed policy"
  type        = string
  default     = null
}

variable "policy_name" {
  description = "Name for managed policy"
  type        = string
  default     = null
}

variable "policy_description" {
  description = "Description of managed policy"
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Policy path - defaults to /"
  type        = string
  default     = null
}

variable "create_linked_role" {
  description = "Whether or not to create linked role"
  type        = bool
  default     = false
}

variable "aws_service_name" {
  description = "AWS service for linked role"
  type        = string
  default     = null
}

variable "linked_role_description" {
  description = "Linked role description"
  type        = string
  default     = null
}

variable "custom_suffix" {
  description = "custom suffix to add to linked role"
  type        = string
  default     = null
}

variable "create_saml_provider" {
  description = "Whether or not to create a SAML provider"
  type        = bool
  default     = false
}

variable "saml_name" {
  description = "Name to create"
  type        = string
  default     = null
}

variable "saml_metadata_document" {
  description = "SAML doc"
  type        = string
  default     = null
}

variable "role_depends_on" {
  description = "Ensure dependancies are created prior to role"
  type        = list(string)
  default     = []
}
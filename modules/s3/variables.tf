variable "bucket_names" {
  description = "The name of the buckets that will be created"
  type        = list(any)
  default     = null
}
variable "codebuild_bucket" {
  description = "The name of the buckets that will be created"
  default     = null
}

variable "acl" {
  description = "(Optional) The canned ACL to apply. Defaults to 'private'. Conflicts with `grant`"
  type        = string
  default     = "private"
}

variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "server_side_encryption_configuration" {
  description = "Map containing server-side encryption configuration."
  type        = any
  default     = {}
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket"
}

variable "logging" {
  type = object({
    bucket_name = string
    prefix      = string
  })
  default     = null
  description = "Bucket access logging configuration."
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
}

variable "kms_master_key_arn" {
  type        = string
  default     = ""
  description = "The AWS KMS master key ARN used for the `SSE-KMS` encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms`"
}

variable "bucket_key_enabled" {
  type        = bool
  default     = false
  description = <<-EOT
  Set this to true to use Amazon S3 Bucket Keys for SSE-KMS, which reduce the cost of AWS KMS requests.
  For more information, see: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html
  EOT
}

variable "website_inputs" {

  type = list(object({
    index_document           = string
    error_document           = string
    redirect_all_requests_to = string
    routing_rules            = string
  }))
  default = null

  description = "Specifies the static website hosting configuration object."
}

variable "lifecycle_rules" {
  description = "A data structure to create lifcycle rules"
  type = list(object({
    id                                     = string
    prefix                                 = string
    tags                                   = map(string)
    enabled                                = bool
    abort_incomplete_multipart_upload_days = number
    expiration_config = list(object({
      days                         = number
      expired_object_delete_marker = bool
    }))
    noncurrent_version_expiration_config = list(object({
      days = number
    }))
    transitions_config = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_transitions_config = list(object({
      days          = number
      storage_class = string
    }))
  }))
  default = []
}


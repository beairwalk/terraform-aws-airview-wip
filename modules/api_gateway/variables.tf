variable "name" {
  description = "Name of the API gateway deployment"
  type        = string
}

variable "description" {
  default = "api created with the help of terraform"
}

variable "types" {
  default     = ["EDGE"]
  type        = list(string)
  description = <<EOT
A list of endpoint types. This resource currently only supports managing a single value.
Valid values: EDGE, REGIONAL or PRIVATE. If unspecified, defaults to EDGE. Must be declared as REGIONAL in non-Commercial partitions.
Refer to the documentation for more information on the difference between edge-optimized and regional APIs.
EOT
}

variable "minimum_compression_size" {
  type        = number
  default     = -1
  description = "Minimum response size to compress for the REST API. Integer between -1 and 10485760 (10MB). Setting a value greater than -1 will enable compression, -1 disables compression (default)."
}

variable "api_key_source" {
  type        = string
  default     = "HEADER"
  description = "The source of the API key for requests. Valid values are HEADER (default) and AUTHORIZER."
}

variable "version_id" {
  description = "version of this component.everytime when we are updating this component we need to increment it."
  default     = "1"
}

variable "binary_media_types" {
  type        = list(any)
  default     = ["UTF-8-encoded"]
  description = "The list of binary media types supported by the RestApi. By default, the RestApi supports only UTF-8-encoded text payloads."
}

variable "end_point_type" {
  description = "it can be EDGE, REGIONAL or PRIVATE"
  type        = list(any)
  default     = ["EDGE"]
}

variable "vpc_endpoint_ids" {
  type    = list(any)
  default = []
}

variable "method" {
  description = "The HTTP method"
  default     = "GET"
}

variable "identity_source" {
  default     = "method.request.header.x-api-key"
  type        = string
  description = <<EOT
The source of the identity in an incoming request.
For REQUEST type, this may be a comma-separated list of values, including headers, query string parameters and stage variables - e.g.
`"method.request.header.SomeHeaderName,method.request.querystring.SomeQueryStringName,stageVariables.SomeStageVariableName"`
EOT
}

variable "log_retention_in_days" {
  default     = 30
  description = "Days to retain apigateway logs"
  type        = number
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  default     = ""
}

variable "cognito_user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  default     = ""
}

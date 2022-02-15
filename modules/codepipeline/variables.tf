variable "codestar_connection_name" {
  type    = string
  default = null
}

variable "codepipeline_webhook_name" {
  type    = string
  default = null
}

variable "provider_type" {
  type    = string
  default = "GitHub"
}

variable "codepipeline_role" {
  description = "A predefined service role to be used"
  type        = string
  default     = null
}

variable "codepipeline_project_name" {
  type        = string
  description = "Codepipeline Project Name"
}

variable "projectname" {
  type        = string
  description = "Codebbuild Project Name"
}

variable "codestar_connection_arn" {
  type        = string
  description = "CodeStar connection ARN required for Github integration with CodePipeline"
  default     = ""
}

variable "branch" {
  type        = string
  description = "Branch of the GitHub repository, _e.g._ `master`"
}

variable "repository_name" {
  type        = string
  description = "GitHub repository name of the application to be built"
}

variable "s3_artifact_bucket" {
  type        = string
  default     = null
  description = "Bucket where the artifact will be stored"
}

variable "webhook_enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any webhook resources"
  default     = true
}

variable "webhook_target_action" {
  type        = string
  description = "The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline"
  default     = "Source"
}

variable "webhook_authentication" {
  type        = string
  description = "The type of authentication to use. One of IP, GITHUB_HMAC, or UNAUTHENTICATED"
  default     = "GITHUB_HMAC"
}

variable "webhook_filter_json_path" {
  type        = string
  description = "The JSON path to filter on"
  default     = "$.ref"
}

variable "webhook_filter_match_equals" {
  type        = string
  description = "The value to match on (e.g. refs/heads/{Branch})"
  default     = "refs/heads/{Branch}"
}

variable "github_token" {
  type        = string
  default     = ""
  description = "GitHub token used for API access. If not provided, can be sourced from the `GITHUB_TOKEN` environment variable"
}

variable "github_organization" {
  type        = string
  description = "GitHub organization to use when creating webhooks"
}

variable "github_base_url" {
  type        = string
  description = "GitHub target API endpoint"
  default     = "https://api.github.com/"
}

variable "github_repositories" {
  type        = list(string)
  description = "List of repository names which should be associated with the webhook"
  default     = []
}

variable "webhook_url" {
  type        = string
  description = "Webhook URL"
}

variable "webhook_content_type" {
  type        = string
  description = "Webhook Content Type (e.g. `json`)"
  default     = "json"
}

variable "webhook_secret" {
  type        = string
  description = "Webhook secret"
  default     = ""
}

variable "webhook_insecure_ssl" {
  type        = bool
  description = "Webhook Insecure SSL (e.g. trust self-signed certificates)"
  default     = false
}

variable "active" {
  type        = bool
  description = "Indicate of the webhook should receive events"
  default     = true
}

variable "events" {
  # Full list of events available here: https://developer.github.com/v3/activity/events/types/
  type        = list(string)
  description = "A list of events which should trigger the webhook."
  default     = ["issue_comment", "pull_request", "pull_request_review", "pull_request_review_comment"]
}

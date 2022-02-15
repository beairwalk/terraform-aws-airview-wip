variable "iam_role" {
  description = "A predefined service role to be used"
  type        = string
  default     = null
}

variable "build_bucket" {
  description = "The ARN of the S3 bucket, path prefix and object key that contains the PEM-encoded certificate."
  type        = string
  default     = null
}

variable "project_name" {
  description = "The projects name."
  type        = string
}

variable "build_timeout" {
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed.The default is 60 minutes."
  type        = number
  default     = 60
}

variable "environment" {
  description = "Information about the project's build environment."
  type        = any
  default     = {}
}

variable "environment_compute_type" {
  description = "Information about the compute resources the build project will use. Available values for this parameter are: `BUILD_GENERAL1_SMALL`, `BUILD_GENERAL1_MEDIUM`, `BUILD_GENERAL1_LARGE` or `BUILD_GENERAL1_2XLARGE`. `BUILD_GENERAL1_SMALL` is only valid if type is set to `LINUX_CONTAINER`. When type is set to `LINUX_GPU_CONTAINER`, compute_type need to be `BUILD_GENERAL1_LARGE`."
  type        = string
  default     = "BUILD_GENERAL1_MEDIUM"
}

variable "environment_image" {
  description = "The Docker image to use for this build project. Valid values include Docker images provided by CodeBuild (e.g `aws/codebuild/standard:2.0`), Docker Hub images (e.g. `hashicorp/terraform:latest`), and full Docker repository URIs such as those for ECR (e.g. `137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest`)"
  type        = string
  default     = "aws/codebuild/standard:2.0"
}

variable "environment_type" {
  description = "The type of build environment to use for related builds. Available values are: `LINUX_CONTAINER`, `LINUX_GPU_CONTAINER`, `WINDOWS_CONTAINER` or `ARM_CONTAINER`."
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "environment_image_pull_credentials_type" {
  description = "The type of credentials AWS CodeBuild uses to pull images in your build. Available values for this parameter are `CODEBUILD` or `SERVICE_ROLE`. When you use a cross-account or private registry image, you must use SERVICE_ROLE credentials. When you use an AWS CodeBuild curated image, you must use CODEBUILD credentials."
  type        = string
  default     = "CODEBUILD"
}

variable "environment_variables" {
  description = "A list of sets of environment variables to make available to builds for this build project."
  type        = list(any)
  default     = []
}

variable "environment_privileged_mode" {
  description = "If set to true, enables running the Docker daemon inside a Docker container."
  type        = bool
  default     = false
}

variable "environment_certificate" {
  description = "The ARN of the S3 bucket, path prefix and object key that contains the PEM-encoded certificate."
  type        = string
  default     = null
}

variable "environment_registry_credential" {
  description = "Information about credentials for access to a private Docker registry. Registry Credential config blocks are documented below."
  type        = map(any)
  default     = {}
}

variable "artifacts" {
  description = "Information about the project's build output artifacts."
  type        = any
  default     = {}
}

variable "artifacts_type" {
  description = "The build output artifact's type. Valid values for this parameter are: `CODEPIPELINE`, `NO_ARTIFACTS` or `S3`."
  type        = string
  default     = "CODEPIPELINE"
}

variable "artifacts_artifact_identifier" {
  description = "The artifact identifier. Must be the same specified inside AWS CodeBuild buildspec."
  type        = string
  default     = null
}

variable "artifacts_encryption_disabled" {
  description = "If set to true, output artifacts will not be encrypted. If `type` is set to `NO_ARTIFACTS` then this value will be ignored."
  type        = bool
  default     = false
}

variable "artifacts_override_artifact_name" {
  description = "If set to true, a name specified in the build spec file overrides the artifact name."
  type        = bool
  default     = false
}

variable "artifacts_location" {
  description = "Information about the build output artifact location. If `type` is set to `CODEPIPELINE` or `NO_ARTIFACTS` then this value will be ignored. If `type` is set to `S3`, this is the name of the output bucket."
  type        = string
  default     = null
}

variable "artifacts_name" {
  description = "The name of the project. If `type` is set to `S3`, this is the name of the output artifact object."
  type        = string
  default     = null
}

variable "artifacts_namespace_type" {
  description = "The namespace to use in storing build artifacts. If `type` is set to `S3`, then valid values for this parameter are: `BUILD_ID` or `NONE`."
  type        = string
  default     = null
}

variable "artifacts_packaging" {
  description = "The type of build output artifact to create. If `type` is set to `S3`, valid values for this parameter are: `NONE` or `ZIP`"
  type        = string
  default     = null
}

variable "artifacts_path" {
  description = "If `type` is set to `S3`, this is the path to the output artifact"
  type        = string
  default     = ""
}

variable "codebuild_source_version" {
  description = "A version of the build input to be built for this project. If not specified, the latest version is used."
  type        = string
  default     = null
}


variable "codebuild_source" {
  description = "Information about the project's input source code."
  type        = any
  default     = {}
}

variable "codebuild_source_type" {
  description = "The type of repository that contains the source code to be built. Valid values for this parameter are: `CODECOMMIT`, `CODEPIPELINE`, `GITHUB`, `GITHUB_ENTERPRISE`, `BITBUCKET`, `S3` or `NO_SOURCE`."
  type        = string
  default     = "CODEPIPELINE"
}

variable "codebuild_source_buildspec" {
  description = "The build spec declaration to use for this build project's related builds. This must be set when type is iNO_SOURCE`"
  type        = string
  default     = null
}

variable "codebuild_source_git_clone_depth" {
  description = "Information about the Git submodules configuration for an AWS CodeBuild build project. Git submodules config blocks are documented below. This option is only valid when the type is `CODECOMMIT`."
  type        = number
  default     = 0
}

variable "codebuild_source_insecure_ssl" {
  description = "Ignore SSL warnings when connecting to source control."
  type        = bool
  default     = false
}

variable "codebuild_source_location" {
  description = "The location of the source code from git or s3."
  type        = string
  default     = null
}

variable "codebuild_source_report_build_status" {
  description = "Set to true to report the status of a build's start and finish to your source provider. This option is only valid when the type is `BITBUCKET` or `GITHUB`."
  type        = bool
  default     = false
}

variable "codebuild_source_auth" {
  description = "Information about the authorization settings for AWS CodeBuild to access the source code to be built."
  type        = map(any)
  default     = {}
}

variable "codebuild_source_auth_type" {
  description = "The authorization type to use. The only valid value is OAUTH"
  type        = string
  default     = "OAUTH"
}

variable "codebuild_source_auth_resource" {
  description = "The resource value that applies to the specified authorization type."
  type        = string
  default     = null
}

variable "codebuild_source_git_submodules_config" {
  description = "Information about the Git submodules configuration for an AWS CodeBuild build project. Git submodules config blocks are documented below. This option is only valid when the type is `CODECOMMIT`."
  type        = map(any)
  default     = {}
}

variable "codebuild_source_git_submodules_config_fetch_submodules" {
  description = "If set to true, fetches Git submodules for the AWS CodeBuild build project."
  type        = bool
  default     = true
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

resource "aws_codebuild_project" "this" {
  name          = var.project_name
  build_timeout = var.build_timeout
  service_role  = var.iam_role

  dynamic "artifacts" {
    for_each = local.artifacts
    content {
      type                   = lookup(artifacts.value, "type")
      artifact_identifier    = lookup(artifacts.value, "artifact_identifier")
      encryption_disabled    = lookup(artifacts.value, "encryption_disabled")
      override_artifact_name = lookup(artifacts.value, "override_artifact_name")
      location               = lookup(artifacts.value, "location")
      name                   = lookup(artifacts.value, "name")
      namespace_type         = lookup(artifacts.value, "namespace_type")
      packaging              = lookup(artifacts.value, "packaging")
      path                   = lookup(artifacts.value, "path")
    }
  }

  dynamic "environment" {
    for_each = local.environment
    content {
      compute_type                = lookup(environment.value, "compute_type")
      image                       = lookup(environment.value, "image")
      type                        = lookup(environment.value, "type")
      image_pull_credentials_type = lookup(environment.value, "image_pull_credentials_type")
      privileged_mode             = lookup(environment.value, "privileged_mode")
      certificate                 = lookup(environment.value, "certificate")

      dynamic "registry_credential" {
        for_each = length(lookup(environment.value, "registry_credential")) == 0 ? [] : [lookup(environment.value, "registry_credential")]
        content {
          credential          = registry_credential.value.credential
          credential_provider = registry_credential.value.credential_provider
        }
      }

      dynamic "environment_variable" {
        for_each = length(lookup(environment.value, "variables")) == 0 ? [] : lookup(environment.value, "variables")
        content {
          name  = environment_variable.value.name
          value = environment_variable.value.value
          type  = lookup(environment_variable.value, "type", null) == null ? "PLAINTEXT" : environment_variable.value.type
        }
      }
    }
  }

  dynamic "source" {
    for_each = local.source
    content {
      type                = lookup(source.value, "type")
      buildspec           = lookup(source.value, "buildspec")
      git_clone_depth     = lookup(source.value, "git_clone_depth")
      insecure_ssl        = lookup(source.value, "insecure_ssl")
      location            = lookup(source.value, "location")
      report_build_status = lookup(source.value, "report_build_status")

      dynamic "auth" {
        for_each = length(lookup(source.value, "auth")) == 0 ? [] : [lookup(source.value, "auth")]
        content {
          type     = auth.value.type
          resource = auth.value.resource
        }
      }

      dynamic "git_submodules_config" {
        for_each = length(lookup(source.value, "git_submodules_config")) == 0 ? [] : [lookup(source.value, "git_submodules_config")]
        content {
          fetch_submodules = git_submodules_config.value.fetch_submodules
        }
      }

    }
  }

  tags = var.tags

}

locals {
  artifacts = [
    {
      type                   = lookup(var.artifacts, "type", null) == null ? var.artifacts_type : lookup(var.artifacts, "type")
      artifact_identifier    = lookup(var.artifacts, "artifact_identifier", null) == null ? var.artifacts_artifact_identifier : lookup(var.artifacts, "artifact_identifier")
      encryption_disabled    = lookup(var.artifacts, "encryption_disabled", null) == null ? var.artifacts_encryption_disabled : lookup(var.artifacts, "encryption_disabled")
      override_artifact_name = lookup(var.artifacts, "override_artifact_name", null) == null ? var.artifacts_override_artifact_name : lookup(var.artifacts, "override_artifact_name")
      location               = lookup(var.artifacts, "location", null) == null ? var.artifacts_location : lookup(var.artifacts, "location")
      name                   = lookup(var.artifacts, "name", null) == null ? var.artifacts_name : lookup(var.artifacts, "name")
      namespace_type         = lookup(var.artifacts, "namespace_type", null) == null ? var.artifacts_namespace_type : lookup(var.artifacts, "namespace_type")
      packaging              = lookup(var.artifacts, "packaging", null) == null ? var.artifacts_packaging : lookup(var.artifacts, "packaging")
      path                   = lookup(var.artifacts, "path", null) == null ? var.artifacts_path : lookup(var.artifacts, "path")
    }
  ]

  environment = [
    {
      compute_type                = lookup(var.environment, "compute_type", null) == null ? var.environment_compute_type : lookup(var.environment, "compute_type")
      image                       = lookup(var.environment, "image", null) == null ? var.environment_image : lookup(var.environment, "image")
      type                        = lookup(var.environment, "type", null) == null ? var.environment_type : lookup(var.environment, "type")
      image_pull_credentials_type = lookup(var.environment, "image_pull_credentials_type", null) == null ? var.environment_image_pull_credentials_type : lookup(var.environment, "image_pull_credentials_type")
      variables                   = lookup(var.environment, "variables", null) == null ? var.environment_variables : lookup(var.environment, "variables")
      privileged_mode             = lookup(var.environment, "privileged_mode", null) == null ? var.environment_privileged_mode : lookup(var.environment, "privileged_mode")
      certificate                 = lookup(var.environment, "certificate ", null) == null ? var.environment_certificate : lookup(var.environment, "certificate")
      registry_credential         = lookup(var.environment, "registry_credential", null) == null ? var.environment_registry_credential : lookup(var.environment, "registry_credential")
    }
  ]

  source = [
    {
      type                  = lookup(var.codebuild_source, "type", null) == null ? var.codebuild_source_type : lookup(var.codebuild_source, "type")
      buildspec             = lookup(var.codebuild_source, "buildspec", null) == null ? var.codebuild_source_buildspec : lookup(var.codebuild_source, "buildspec")
      git_clone_depth       = lookup(var.codebuild_source, "git_clone_depth", null) == null ? var.codebuild_source_git_clone_depth : lookup(var.codebuild_source, "git_clone_depth")
      insecure_ssl          = lookup(var.codebuild_source, "insecure_ssl", null) == null ? var.codebuild_source_insecure_ssl : lookup(var.codebuild_source, "insecure_ssl")
      location              = lookup(var.codebuild_source, "location", null) == null ? var.codebuild_source_location : lookup(var.codebuild_source, "location")
      report_build_status   = lookup(var.codebuild_source, "report_build_status", null) == null ? var.codebuild_source_report_build_status : lookup(var.codebuild_source, "report_build_status")
      auth                  = lookup(var.codebuild_source, "auth", null) == null ? var.codebuild_source_auth : lookup(var.codebuild_source, "auth")
      git_submodules_config = lookup(var.codebuild_source, "git_submodules_config", null) == null ? var.codebuild_source_git_submodules_config : lookup(var.codebuild_source, "git_submodules_config")
    }
  ]

}



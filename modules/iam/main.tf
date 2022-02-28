resource "aws_iam_role" "airview_iam_role" {
  count = var.create_role ? 1 : 0

  name                 = var.role_name
  description          = var.role_description
  path                 = var.role_path
  permissions_boundary = var.role_permissions_boundary_arn

  assume_role_policy = var.assume_role_policy

  tags = var.tags

  depends_on = [var.role_depends_on]
}

resource "aws_iam_policy" "airview_iam_policy" {
  count = var.create_policy && var.create_role ? 1 : 0

  name        = var.policy_name
  description = var.policy_description
  path        = var.policy_path

  policy = var.policy
}

resource "aws_iam_role_policy" "airview_iam_role_policy" {
  count = var.create_role_policy && var.create_role ? 1 : 0

  name = var.role_policy_name
  role = aws_iam_role.airview_iam_role[0].id

  policy = var.role_policy
}

resource "aws_iam_role_policy_attachment" "airview_iam_role_policy_attachment" {
  count = var.create_role_policy_attachment && var.create_role ? length(var.policy_arn) : 0

  role       = aws_iam_role.airview_iam_role[0].name
  policy_arn = element(var.policy_arn, count.index)
}

resource "aws_iam_instance_profile" "airview_iam_instance_profile" {
  count = var.create_role && var.create_instance_profile ? 1 : 0

  name = var.role_name
  path = var.role_path
  role = aws_iam_role.airview_iam_role[0].name
}

resource "aws_iam_service_linked_role" "airview_iam_service_linked_role" {
  count = var.create_linked_role ? 1 : 0

  aws_service_name = var.aws_service_name
  description      = var.linked_role_description
  custom_suffix    = var.custom_suffix
}

resource "aws_iam_saml_provider" "airview_iam_saml_provider" {
  count = var.create_saml_provider ? 1 : 0

  name                   = var.saml_name
  saml_metadata_document = var.saml_metadata_document
}
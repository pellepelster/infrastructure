resource "aws_organizations_account" "pelle_io" {
  name      = "pelle-io"
  email     = local.pelle_io_account_email
  parent_id = data.aws_organizations_organization.pelle_io.roots[0].id

  role_name         = "OrganizationAccountAccessRole"
  close_on_deletion = true

  lifecycle {
    ignore_changes = [role_name]
  }
}

resource "aws_iam_user" "pelle_io_admin" {
  name     = "admin"
  provider = aws.pelle_io
}

resource "aws_iam_user_policy_attachment" "pelle_io_admin" {
  user       = aws_iam_user.pelle_io_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  provider   = aws.pelle_io
}

resource "aws_iam_access_key" "pelle_io_admin" {
  user     = aws_iam_user.pelle_io_admin.name
  provider = aws.pelle_io
}

resource "aws_iam_user_login_profile" "pelle_io_admin" {
  user                    = aws_iam_user.pelle_io_admin.name
  password_reset_required = true
  provider                = aws.pelle_io
}

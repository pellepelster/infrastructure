resource "aws_organizations_account" "pelle_io" {
  name      = "pelle_io"
  email     = var.pelle_io_account_email
  parent_id = data.aws_organizations_organization.pelle_io.roots[0].id

  role_name         = "OrganizationAccountAccessRole"
  close_on_deletion = true

  lifecycle {
    ignore_changes = [role_name]
  }
}

resource "aws_iam_user" "pelle_io_admin" {
  provider = aws.pelle_io
  name     = "admin"
}

resource "aws_iam_user_policy_attachment" "pelle_io_admin" {
  provider   = aws.pelle_io
  user       = aws_iam_user.pelle_io_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "pelle_io_admin" {
  provider = aws.pelle_io
  user     = aws_iam_user.pelle_io_admin.name
}


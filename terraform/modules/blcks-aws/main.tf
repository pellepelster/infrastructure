locals {
  name = "blcks-${var.environment}"
}

resource "aws_iam_user" "admin" {
  name = "admin"
}

resource "aws_iam_user_policy_attachment" "admin" {
  user       = aws_iam_user.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "admin" {
  user = aws_iam_user.admin.name
}

resource "aws_iam_user_login_profile" "admin" {
  user                    = aws_iam_user.admin.name
  password_reset_required = true
}

module "terraform_state" {
  source = "../terraform-state-bucket"

  name = local.name
}

output "admin_access_key" {
  value     = aws_iam_access_key.admin.id
  sensitive = true
}

output "admin_secret_access_key" {
  value     = aws_iam_access_key.admin.secret
  sensitive = true
}

output "admin_password" {
  value     = aws_iam_user_login_profile.admin.password
  sensitive = true
}

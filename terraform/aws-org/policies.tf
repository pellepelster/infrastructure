resource "aws_organizations_policy" "guardrails" {
  name = "guardrails"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyLeaveOrganization"
        Effect   = "Deny"
        Action   = "organizations:LeaveOrganization"
        Resource = "*"
      },
      {
        Sid      = "DenyRootUser"
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          StringLike = {
            "aws:PrincipalArn" = "arn:aws:iam::*:root"
          }
        }
      },
      {
        Sid    = "DenyCloudTrailTampering"
        Effect = "Deny"
        Action = [
          "cloudtrail:StopLogging",
          "cloudtrail:DeleteTrail",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_organizations_policy" "allowed_regions" {
  name = "allowed-regions"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyOutsideAllowedRegions"
        Effect = "Deny"
        NotAction = [
          "budgets:*",
          "ce:*",
          "cloudfront:*",
          "cur:*",
          "health:*",
          "iam:*",
          "organizations:*",
          "route53:*",
          "route53domains:*",
          "shield:*",
          "sts:*",
          "support:*",
          "trustedadvisor:*",
          "waf:*",
          "wafv2:*",
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = [
              "eu-central-1",
              "us-east-1",
            ]
          }
          ArnNotLike = {
            "aws:PrincipalArn" = "arn:aws:iam::*:role/OrganizationAccountAccessRole"
          }
        }
      },
    ]
  })
}

resource "aws_organizations_policy_attachment" "guardrails" {
  policy_id = aws_organizations_policy.guardrails.id
  target_id = data.aws_organizations_organization.pelle_io.roots[0].id
}

resource "aws_organizations_policy_attachment" "allowed_regions" {
  policy_id = aws_organizations_policy.allowed_regions.id
  target_id = data.aws_organizations_organization.pelle_io.roots[0].id
}

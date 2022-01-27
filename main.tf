resource "aws_iam_role" "this" {
  name = "NetworkingAccountAccess"
  description = "Allows the common networking account to tag resources it shared with us"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.account_id]
    }
  }
}

resource "aws_iam_role_policy" "allow_tagging" {
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.allow_tagging.json
}

data "aws_iam_policy_document" "allow_tagging" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeSubnets",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeTags",
    ]
    resources = ["arn:aws:ec2:*:*:subnet/*"]
  }
}

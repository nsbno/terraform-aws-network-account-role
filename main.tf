resource "aws_iam_role" "this" {
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
    ]
    resources = ["arn:aws:ec2:*:*:subnet/*"]
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = var.trust_services # e.g., ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "inline" {
  for_each = { for p in var.inline_policies : p.name => p if p.document != null }
  name     = each.value.name
  role     = aws_iam_role.iam.id
  policy   = each.value.document
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each  = toset(var.managed_policy_arns)
  role      = aws_iam_role.iam.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "iam_instance" {
  count = var.create_instance_profile ? 1 : 0
  name  = "${var.name}-profile"
  role  = aws_iam_role.iam.name
  tags  = var.tags
}

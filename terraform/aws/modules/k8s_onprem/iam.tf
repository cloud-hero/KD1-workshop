resource "aws_iam_role" "ssm_role" {
  name = "${var.project_name}-${var.instance_name}-SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "describe_tags" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.project_name}-${var.instance_name}-SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}

output "ssm_profile_id" {
  value = aws_iam_instance_profile.ssm_profile.id
}

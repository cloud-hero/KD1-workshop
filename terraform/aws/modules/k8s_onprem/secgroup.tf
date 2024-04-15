resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.instance_name}"
  description = "Allows All Access"
  vpc_id      = var.vpc_id

  ingress {
    self        = true
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.instance_name}"
  }
}
/**
 * # Terraform AWS tool instance Module
 *
 * アプリケーションサーバやDBに対して手動でコマンド実行等を実施するためのEC2インスタンスを作成します。
 * AMIはデフォルトでAmazonLinux2(Arm64)の最新版を使用します。
 * インスタンスへはSessionManagerを使用して接続する想定であるため、SessionManger接続権限を含んだIAMポリシーARNを渡す必要があります。
 */

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "tool" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami = var.ami == null ? data.aws_ami.tool.image_id : var.ami
}

resource "aws_instance" "tool" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.tool.id
  vpc_security_group_ids = [aws_security_group.tool.id]
  key_name               = aws_key_pair.tool.key_name
  disable_api_termination = true
  tags = {
    Name = "${var.tf.fullname}-tool"
  }
}

resource "aws_key_pair" "tool" {
  key_name   = "${var.tf.fullname}-tool"
  public_key = file(var.public_key_path)
}

resource "aws_iam_instance_profile" "tool" {
  name = "${var.tf.fullname}-tool"
  role = aws_iam_role.tool.name
}

resource "aws_iam_role" "tool" {
  name               = "${var.tf.fullname}-tool"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "tool_attach_AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.tool.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "tool_attach_session_manager_policy" {
  role       = aws_iam_role.tool.name
  policy_arn = var.session_manager_policy_arn
}

resource "aws_security_group" "tool" {
  name        = "tool"
  description = "tool security group"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-tool"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/**
 * # Terraform AWS Bastion Module
 *
 * プライベートサブネットに配置されているRDS等への接続時に使用するBastion（踏み台）インスタンスを構築します。
 * AMIはデフォルトでAmazonLinux2(Arm64)の最新版を使用します。
 * BastionインスタンスへはSessionManagerを使用して接続する想定であるため、SessionManger接続権限を含んだIAMポリシーARNを渡す必要があります。
 */

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_name_filter]
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

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.bastion.image_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.bastion.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = aws_key_pair.bastion.key_name
  disable_api_termination = true
  tags = {
    Name = "${var.tf.fullname}-bastion"
  }
}

resource "aws_key_pair" "bastion" {
  key_name   = "${var.tf.fullname}-bastion"
  public_key = file(var.public_key_path)
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.tf.fullname}-bastion"
  role = aws_iam_role.bastion.name
}

resource "aws_iam_role" "bastion" {
  name               = "${var.tf.fullname}-bastion"
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

resource "aws_iam_role_policy_attachment" "bastion_attach_AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "bastion_attach_session_manager_policy" {
  role       = aws_iam_role.bastion.name
  policy_arn = var.session_manager_policy_arn
}

resource "aws_security_group" "bastion" {
  name        = "${var.tf.fullname}-bastion"
  description = "bastion(${var.tf.env}) security group"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

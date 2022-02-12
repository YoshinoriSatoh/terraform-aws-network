/**
 * # Terraform AWS Network NAT Instance module
 *
 * VPCにNATインスタンスを作成し、privateサブネットのルートテーブルにNATインスタンスへのルーティングを追加します。
 */

data "aws_ami" "nat" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*-x86_64-ebs"]
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
  ami = var.ami == null ? data.aws_ami.nat.image_id : var.ami
}

resource "aws_instance" "nat_a" {
  ami                         = local.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnets.a.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.nat.id
  vpc_security_group_ids      = [aws_security_group.nat_instance.id]
  key_name                    = aws_key_pair.instance.key_name
  source_dest_check           = false
  disable_api_termination     = !var.in_development
  tags = {
    Name               = "${var.tf.fullname}-nat-instance-a"
    AllowSessionManger = true
  }
}

resource "aws_eip" "nat_instance_a" {
  vpc      = true
  instance = aws_instance.nat_a.id
  tags = {
    Name = "${var.tf.fullname}-nat-instance-a"
  }
}

resource "aws_instance" "nat_c" {
  count                       = var.multi_az ? 1 : 0
  ami                         = local.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnets.c.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.nat.id
  vpc_security_group_ids      = [aws_security_group.nat_instance.id]
  key_name                    = aws_key_pair.instance.key_name
  source_dest_check           = false
  disable_api_termination     = !var.in_development
  tags = {
    Name               = "${var.tf.fullname}-nat-instance-c"
    AllowSessionManger = true
  }
}

resource "aws_eip" "nat_instance_c" {
  count    = var.multi_az ? 1 : 0
  vpc      = true
  instance = aws_instance.nat_c[0].id
  tags = {
    Name = "${var.tf.fullname}-nat-instance-c"
  }
}

resource "aws_key_pair" "instance" {
  key_name   = "${var.tf.fullname}-instance"
  public_key = file(var.public_key_path)
}

resource "aws_iam_instance_profile" "nat" {
  name = "${var.tf.fullname}-nat"
  role = aws_iam_role.nat_instance.name
}

resource "aws_route_table" "private_a" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-private-a"
  }

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_a.id
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = var.routing_subnets.private.a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table" "private_c" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-private-c"
  }

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = var.multi_az ? aws_instance.nat_c[0].id : aws_instance.nat_a.id
  }
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = var.routing_subnets.private.c.id
  route_table_id = var.multi_az ? aws_route_table.private_c.id : aws_route_table.private_a.id
}

resource "aws_route_table" "tool" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-tool"
  }

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_a.id
  }
}

resource "aws_route_table_association" "tool" {
  subnet_id      = var.routing_subnets.tool.id
  route_table_id = aws_route_table.tool.id
}

resource "aws_iam_role" "nat_instance" {
  name               = "${var.tf.fullname}-nat-instance"
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

resource "aws_iam_role_policy_attachment" "instance_attach_AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.nat_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "instance_attach_session_manager_policy" {
  role       = aws_iam_role.nat_instance.name
  policy_arn = var.session_manager_policy_arn
}

resource "aws_security_group" "nat_instance" {
  name        = "${var.tf.fullname}-nat-instance"
  description = "nat instance(${var.tf.env}) security group"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-nat-instance"
  }

  ingress {
    description = "from private subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      var.routing_subnets.private.a.cidr_block,
      var.routing_subnets.private.c.cidr_block,
      var.routing_subnets.tool.cidr_block
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
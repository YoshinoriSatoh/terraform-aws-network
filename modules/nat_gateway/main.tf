/**
 * # Terraform AWS Network NAT Gateway module
 *
 * VPCにNATゲートウェイを作成し、以下サブネットのルートテーブルにNATインスタンスへのルーティングを追加します。
 * * application
 * * tooling
 */

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_gateway_a.id
  subnet_id     = var.public_subnets.a.id
}

resource "aws_eip" "nat_gateway_a" {
  vpc = true
  tags = {
    Name = "${var.tf.fullname}-nat-gateway-a"
  }
}

resource "aws_route_table" "application_a" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-application-a"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }
}

resource "aws_route_table_association" "application_a" {
  subnet_id      = var.routing_subnets.application.a.id
  route_table_id = aws_route_table.application_a.id
}


resource "aws_nat_gateway" "nat_c" {
  count         = var.multi_az ? 1 : 0
  allocation_id = aws_eip.nat_gateway_c[0].id
  subnet_id     = var.public_subnets.c.id
}

resource "aws_eip" "nat_gateway_c" {
  count = var.multi_az ? 1 : 0
  vpc   = true
  tags = {
    Name = "${var.tf.fullname}-nat-gateway-c"
  }
}

resource "aws_route_table" "application_c" {
  count  = var.multi_az ? 1 : 0
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-application-c"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_c[0].id
  }
}

resource "aws_route_table_association" "application_c" {
  count          = var.multi_az ? 1 : 0
  subnet_id      = var.routing_subnets.application.c.id
  route_table_id = aws_route_table.application_c[0].id
}

resource "aws_route_table" "tooling" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-tooling"
  }

  route {
    cidr_block  = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }
}

resource "aws_route_table_association" "tooling" {
  subnet_id      = var.routing_subnets.tooling.id
  route_table_id = aws_route_table.tooling.id
}

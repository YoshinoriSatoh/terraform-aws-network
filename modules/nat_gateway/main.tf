/**
 * # Terraform AWS Network NAT Gateway module
 *
 * VPCにNATゲートウェイを作成し、privateサブネットのルートテーブルにNATインスタンスへのルーティングを追加します。
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

resource "aws_route_table" "private_a" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-private-a"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = var.routing_subnets.private.a.id
  route_table_id = aws_route_table.private_a.id
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

resource "aws_route_table" "private_c" {
  count  = var.multi_az ? 1 : 0
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tf.fullname}-private-c"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_c[0].id
  }
}

resource "aws_route_table_association" "private_c" {
  count          = var.multi_az ? 1 : 0
  subnet_id      = var.routing_subnets.private.c.id
  route_table_id = aws_route_table.private_c[0].id
}

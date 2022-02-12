/**
 * # Terraform AWS Network Module
 *
 * Webアプリケーション等を想定したVPC及びサブネット群です。
 * 
 * リージョンはproviderのregion指定に依存し、aとcの2つのAZに展開されます。
 * （ap-northeast-1でのみ動作確認)
 * 
 * 一つのVPC内に以下サブネット群を構築します。
 * |  サブネット名   |  用途など  |
 * | ----          | ---- |
 * |  public       |  インターネットインバウンド/アウトバウンドを持つ  |
 * |  private      |  インターネットインバウンドがなく、NATによってインターネットアウトバウンドを構成する |
 */

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.tf.fullname
  }
}

# --- public subnet ---
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}a"
  cidr_block        = var.subnets.public.a.cidr_block
  tags = {
    Name = "${var.tf.fullname}-public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}c"
  cidr_block        = var.subnets.public.c.cidr_block
  tags = {
    Name = "${var.tf.fullname}-public-c"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.tf.fullname}-public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# --- private subnet ---
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}a"
  cidr_block        = var.subnets.private.a.cidr_block
  tags = {
    Name = "${var.tf.fullname}-private-a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}c"
  cidr_block        = var.subnets.private.c.cidr_block
  tags = {
    Name = "${var.tf.fullname}-private-c"
  }
}
resource "aws_db_subnet_group" "main" {
  name        = var.tf.fullname
  description = var.tf.fullname
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]
}

resource "aws_elasticache_subnet_group" "main" {
  name        = var.tf.fullname
  description = var.tf.fullname
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id
  ]
}

# --- bastion instance ---
module "bastion" {
  count                      = var.bastion_enabled ? 1 : 0
  source                     = "./modules/bastion"
  tf                         = var.tf
  vpc_id                     = aws_vpc.main.id
  subnet_id                  = aws_subnet.public_a.id
  session_manager_policy_arn = var.session_manager_policy_arn
  public_key_path            = var.public_key_paths.bastion
  in_development             = var.in_development
}

# --- nat instance ---
module "nat_instance" {
  count  = var.nat_enabled && var.nat_type == "instance" ? 1 : 0
  source = "./modules/nat_instance"
  tf     = var.tf
  vpc_id = aws_vpc.main.id
  public_subnets = {
    a = {
      id = aws_subnet.public_a.id
    }
    c = {
      id = aws_subnet.public_c.id
    }
  }
  routing_subnets = {
    private = {
      a = {
        id         = aws_subnet.private_a.id
        cidr_block = aws_subnet.private_a.cidr_block
      }
      c = {
        id         = aws_subnet.private_c.id
        cidr_block = aws_subnet.private_c.cidr_block
      }
    }
  }
  multi_az                   = var.nat_multi_az
  session_manager_policy_arn = var.session_manager_policy_arn
  public_key_path            = var.public_key_paths.nat
  in_development             = var.in_development
}

# --- nat gateway ---
module "network_nat_gateway" {
  count  = var.nat_enabled && var.nat_type == "gateway" ? 1 : 0
  source = "./modules/nat_gateway"
  tf     = var.tf
  vpc_id = aws_vpc.main.id
  public_subnets = {
    a = {
      id = aws_subnet.public_a.id
    }
    c = {
      id = aws_subnet.public_c.id
    }
  }
  routing_subnets = {
    private = {
      a = {
        id         = aws_subnet.private_a.id
        cidr_block = aws_subnet.private_a.cidr_block
      }
      c = {
        id         = aws_subnet.private_c.id
        cidr_block = aws_subnet.private_c.cidr_block
      }
    }
  }
  multi_az = var.nat_multi_az
}

# --- tool instance ---
module "tool" {
  count                      = var.tool_enabled ? 1 : 0
  source                     = "./modules/tool"
  tf                         = var.tf
  vpc_id                     = aws_vpc.main.id
  subnet_id                  = aws_subnet.public_a.id
  session_manager_policy_arn = var.session_manager_policy_arn
  public_key_path            = var.public_key_paths.tool
  in_development             = var.in_development
}


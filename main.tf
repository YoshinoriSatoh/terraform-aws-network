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
 * |  public       |  ALB等インターネットへ公開するリソースを配置  |
 * |  application  |  稼働時及びデプロイ時にインターネットアウトバウンドが必要なアプリケーションを配置（インターネットアウトバウンド自体は別途構成が必要）   |
 * |  database     |  RDSやElastiCache等のリソースを配置（インターネットアウトバウンドなし）  |
 * |  tooling      |  AWSリソース、アプリケーションサーバ等に対するCLIによる操作等、アプリケーションワークロード以外で必要なリソースを配置（メンテナンス用のEC2インスタンスなど）（インターネットアウトバウンドなし）  |
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
resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}a"
  cidr_block        = var.subnets.public.a.cidr_block
  tags = {
    Name = "${var.tf.fullname}-public-a"
  }
}

resource "aws_subnet" "public-c" {
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

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# --- application subnet ---
resource "aws_subnet" "application-a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}a"
  cidr_block        = var.subnets.application.a.cidr_block
  tags = {
    Name = "${var.tf.fullname}-application-a"
  }
}

resource "aws_subnet" "application-c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}c"
  cidr_block        = var.subnets.application.c.cidr_block
  tags = {
    Name = "${var.tf.fullname}-application-c"
  }
}

# --- database subnet ---
resource "aws_subnet" "database-a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}a"
  cidr_block        = var.subnets.database.a.cidr_block
  tags = {
    Name = "${var.tf.fullname}-database-a"
  }
}

resource "aws_subnet" "database-c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}c"
  cidr_block        = var.subnets.database.c.cidr_block
  tags = {
    Name = "${var.tf.fullname}-database-c"
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.tf.fullname}-database"
  }
}

resource "aws_route_table_association" "database-a" {
  subnet_id      = aws_subnet.database-a.id
  route_table_id = aws_route_table.database.id
}

resource "aws_route_table_association" "database-c" {
  subnet_id      = aws_subnet.database-c.id
  route_table_id = aws_route_table.database.id
}

# --- tooling subnet ---
resource "aws_subnet" "tooling" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}a"
  cidr_block        = var.subnets.tooling.cidr_block
  tags = {
    Name = "${var.tf.fullname}-tooling"
  }
}

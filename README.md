<!-- BEGIN_TF_DOCS -->
# Terraform AWS Network Module

Webアプリケーション等を想定したVPC及びサブネット群です。

リージョンはproviderのregion指定に依存し、aとcの2つのAZに展開されます。
（ap-northeast-1でのみ動作確認)

一つのVPC内に以下サブネット群を構築します。
|  サブネット名   |  用途など  |
| ----          | ---- |
|  public       |  ALB等インターネットへ公開するリソースを配置  |
|  application  |  稼働時及びデプロイ時にインターネットアウトバウンドが必要なアプリケーションを配置（インターネットアウトバウンド自体は別途構成が必要）   |
|  database     |  RDSやElastiCache等のリソースを配置（インターネットアウトバウンドなし）  |
|  tool      |  AWSリソース、アプリケーションサーバ等に対するCLIによる操作等、アプリケーションワークロード以外で必要なリソースを配置（メンテナンス用のEC2インスタンスなど）（インターネットアウトバウンドなし）  |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/internet_gateway) | resource |
| [aws_route_table.database](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table) | resource |
| [aws_route_table_association.database_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.database_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |
| [aws_subnet.application_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/subnet) | resource |
| [aws_subnet.application_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/subnet) | resource |
| [aws_subnet.database_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/subnet) | resource |
| [aws_subnet.database_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/subnet) | resource |
| [aws_subnet.public_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/subnet) | resource |
| [aws_subnet.public_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/subnet) | resource |
| [aws_subnet.tool](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnets"></a> [subnets](#input\_subnets) | サブネット設定 | <pre>object({<br>    public = object({<br>      a = object({<br>        cidr_block = string<br>      })<br>      c = object({<br>        cidr_block = string<br>      })<br>    })<br>    application = object({<br>      a = object({<br>        cidr_block = string<br>      })<br>      c = object({<br>        cidr_block = string<br>      })<br>    })<br>    database = object({<br>      a = object({<br>        cidr_block = string<br>      })<br>      c = object({<br>        cidr_block = string<br>      })<br>    })<br>    tool = object({<br>      cidr_block = string<br>    })<br>  })</pre> | <pre>{<br>  "application": {<br>    "a": {<br>      "cidr_block": "10.0.12.0/22"<br>    },<br>    "c": {<br>      "cidr_block": "10.0.16.0/22"<br>    }<br>  },<br>  "database": {<br>    "a": {<br>      "cidr_block": "10.0.24.0/22"<br>    },<br>    "c": {<br>      "cidr_block": "10.0.28.0/22"<br>    }<br>  },<br>  "public": {<br>    "a": {<br>      "cidr_block": "10.0.0.0/22"<br>    },<br>    "c": {<br>      "cidr_block": "10.0.4.0/22"<br>    }<br>  },<br>  "tool": {<br>    "cidr_block": "10.0.36.0/22"<br>  }<br>}</pre> | no |
| <a name="input_tf"></a> [tf](#input\_tf) | Terraformアプリケーション情報 | <pre>object({<br>    name          = string<br>    shortname     = string<br>    env           = string<br>    fullname      = string<br>    fullshortname = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC設定 | <pre>object({<br>    cidr_block = string<br>  })</pre> | <pre>{<br>  "cidr_block": "10.0.0.0/16"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_application_a"></a> [subnet\_application\_a](#output\_subnet\_application\_a) | Application subnet of availavitity zone A in main VPC. Internet outbound creation is required, if you needed. |
| <a name="output_subnet_application_c"></a> [subnet\_application\_c](#output\_subnet\_application\_c) | Application subnet of availavitity zone C in main VPC. Internet outbound creation is required, if you needed. |
| <a name="output_subnet_application_ids"></a> [subnet\_application\_ids](#output\_subnet\_application\_ids) | A list of application subnet's id. For unconsciously availavirity zone. |
| <a name="output_subnet_database_a"></a> [subnet\_database\_a](#output\_subnet\_database\_a) | Database subnet of availavitity zone A in main VPC. No internet outbound. |
| <a name="output_subnet_database_c"></a> [subnet\_database\_c](#output\_subnet\_database\_c) | Database subnet of availavitity zone A in main VPC. No internet outbound. |
| <a name="output_subnet_database_ids"></a> [subnet\_database\_ids](#output\_subnet\_database\_ids) | A list of database subnet's id. For unconsciously availavirity zone. |
| <a name="output_subnet_public_a"></a> [subnet\_public\_a](#output\_subnet\_public\_a) | Public subnet of availavitity zone A in main VPC. Has internet outbound. |
| <a name="output_subnet_public_c"></a> [subnet\_public\_c](#output\_subnet\_public\_c) | Public subnet of availavitity zone C in main VPC. Has internet outbound. |
| <a name="output_subnet_public_ids"></a> [subnet\_public\_ids](#output\_subnet\_public\_ids) | A list of public subnet's id. For unconsciously availavirity zone. |
| <a name="output_subnet_tool"></a> [subnet\_tool](#output\_subnet\_tool) | tool subnet of availavitity zone A. (availavitity zone A only) |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | Main vpc |
<!-- END_TF_DOCS -->    
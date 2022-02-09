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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ./modules/bastion | n/a |
| <a name="module_nat_instance"></a> [nat\_instance](#module\_nat\_instance) | ./modules/nat_instance | n/a |
| <a name="module_network_nat_gateway"></a> [network\_nat\_gateway](#module\_network\_nat\_gateway) | ./modules/nat_gateway | n/a |
| <a name="module_tool"></a> [tool](#module\_tool) | ./modules/tool | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.database_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.database_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.application_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.application_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.database_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.database_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.tool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_enabled"></a> [bastion\_enabled](#input\_bastion\_enabled) | Bastionインスタンスの有無を指定します | `bool` | `false` | no |
| <a name="input_in_development"></a> [in\_development](#input\_in\_development) | Terraform構築検証モード（各種リソースの削除保護が無効化されます） | `bool` | `false` | no |
| <a name="input_nat_enabled"></a> [nat\_enabled](#input\_nat\_enabled) | NAT構成の有無を指定します | `bool` | `false` | no |
| <a name="input_nat_multi_az"></a> [nat\_multi\_az](#input\_nat\_multi\_az) | NATインスタンス or ゲートウェイを冗長化します | `bool` | `false` | no |
| <a name="input_nat_type"></a> [nat\_type](#input\_nat\_type) | NAT構成を有効化する場合に、NATインスタンス or NATゲートウェイを指定します | `string` | `"instance"` | no |
| <a name="input_public_key_paths"></a> [public\_key\_paths](#input\_public\_key\_paths) | Bastion/NATインスタンスのキーペアのパブリックキーファイルパス. 呼び出し側でSSHキーを生成の上、ファイルパスを指定してください。 | <pre>object({<br>    bastion = string<br>    nat     = string<br>    tool    = string<br>  })</pre> | <pre>{<br>  "bastion": "./key_pairs/bastion.pub",<br>  "nat": "./key_pairs/nat_instance.pub",<br>  "tool": "./key_pairs/tool.pub"<br>}</pre> | no |
| <a name="input_session_manager_policy_arn"></a> [session\_manager\_policy\_arn](#input\_session\_manager\_policy\_arn) | SessionManager接続権限を含んだIAMポリシーARN (Bastion/NATインスタンスロールへアタッチ) | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | サブネット設定 | <pre>object({<br>    public = object({<br>      a = object({<br>        cidr_block = string<br>      })<br>      c = object({<br>        cidr_block = string<br>      })<br>    })<br>    application = object({<br>      a = object({<br>        cidr_block = string<br>      })<br>      c = object({<br>        cidr_block = string<br>      })<br>    })<br>    database = object({<br>      a = object({<br>        cidr_block = string<br>      })<br>      c = object({<br>        cidr_block = string<br>      })<br>    })<br>    tool = object({<br>      cidr_block = string<br>    })<br>  })</pre> | <pre>{<br>  "application": {<br>    "a": {<br>      "cidr_block": "10.0.12.0/22"<br>    },<br>    "c": {<br>      "cidr_block": "10.0.16.0/22"<br>    }<br>  },<br>  "database": {<br>    "a": {<br>      "cidr_block": "10.0.24.0/22"<br>    },<br>    "c": {<br>      "cidr_block": "10.0.28.0/22"<br>    }<br>  },<br>  "public": {<br>    "a": {<br>      "cidr_block": "10.0.0.0/22"<br>    },<br>    "c": {<br>      "cidr_block": "10.0.4.0/22"<br>    }<br>  },<br>  "tool": {<br>    "cidr_block": "10.0.36.0/22"<br>  }<br>}</pre> | no |
| <a name="input_tf"></a> [tf](#input\_tf) | Terraformアプリケーション情報 | <pre>object({<br>    name          = string<br>    shortname     = string<br>    env           = string<br>    fullname      = string<br>    fullshortname = string<br>  })</pre> | n/a | yes |
| <a name="input_tool_enabled"></a> [tool\_enabled](#input\_tool\_enabled) | toolリソース有無を指定します | `bool` | `false` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC設定 | <pre>object({<br>    cidr_block = string<br>  })</pre> | <pre>{<br>  "cidr_block": "10.0.0.0/16"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_elasticache_subnet_group_main"></a> [aws\_elasticache\_subnet\_group\_main](#output\_aws\_elasticache\_subnet\_group\_main) | main elasticache subnet group |
| <a name="output_db_subnet_group_main"></a> [db\_subnet\_group\_main](#output\_db\_subnet\_group\_main) | main rds subnet group |
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
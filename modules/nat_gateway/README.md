<!-- BEGIN_TF_DOCS -->
# Terraform AWS Network NAT Gateway module

VPCにNATゲートウェイを作成し、以下サブネットのルートテーブルにNATインスタンスへのルーティングを追加します。
* application
* tooling

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
| [aws_eip.nat_gateway_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/eip) | resource |
| [aws_eip.nat_gateway_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/eip) | resource |
| [aws_nat_gateway.nat_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.nat_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/nat_gateway) | resource |
| [aws_route_table.application_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table) | resource |
| [aws_route_table.application_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table) | resource |
| [aws_route_table.tooling](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table) | resource |
| [aws_route_table_association.application_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.application_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.tooling](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | NATインスタンスの冗長化 | `bool` | `false` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | NATインスタンスを起動するサブネットID | <pre>object({<br>    a = object({<br>      id = string<br>    })<br>    c = object({<br>      id = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_routing_subnets"></a> [routing\_subnets](#input\_routing\_subnets) | NATルーティング対象のサブネットID | <pre>object({<br>    application = object({<br>      a = object({<br>        id         = string<br>        cidr_block = string<br>      })<br>      c = object({<br>        id         = string<br>        cidr_block = string<br>      })<br>    })<br>    tooling = object({<br>      id         = string<br>      cidr_block = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_tf"></a> [tf](#input\_tf) | Terraformアプリケーション情報 | <pre>object({<br>    name          = string<br>    shortname     = string<br>    env           = string<br>    fullname      = string<br>    fullshortname = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | NATインスタンスを起動するVPC ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->    
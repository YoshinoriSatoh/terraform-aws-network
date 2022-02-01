<!-- BEGIN_TF_DOCS -->
# Terraform AWS Network NAT Instance module

VPCにNATインスタンスを作成し、以下サブネットのルートテーブルにNATインスタンスへのルーティングを追加します。
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
| [aws_eip.nat_instance_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/eip) | resource |
| [aws_eip.nat_instance_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/eip) | resource |
| [aws_iam_instance_profile.nat](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.nat_instance](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.instance_attach_AmazonSSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.instance_attach_session_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.nat_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/instance) | resource |
| [aws_instance.nat_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/instance) | resource |
| [aws_key_pair.instance](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/key_pair) | resource |
| [aws_route_table.application_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table) | resource |
| [aws_route_table.application_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table) | resource |
| [aws_route_table.tooling](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table) | resource |
| [aws_route_table_association.application_a](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.application_c](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.tooling](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/route_table_association) | resource |
| [aws_security_group.nat_instance](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/security_group) | resource |
| [aws_ami.nat](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | NATインスタンスAMI | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | NATインスタンスタイプ | `string` | `"t3.nano"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | NATインスタンスの冗長化 | `bool` | `false` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Bastionインスタンスのキーペアのパブリックキーファイルパス. 呼び出し側でSSHキーを生成の上、ファイルパスを指定してください。 | `string` | `"./key_pairs/nat_instance.pub"` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | NATインスタンスを起動するサブネットID | <pre>object({<br>    a = object({<br>      id = string<br>    })<br>    c = object({<br>      id = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_routing_subnets"></a> [routing\_subnets](#input\_routing\_subnets) | NATルーティング対象のサブネットID | <pre>object({<br>    application = object({<br>      a = object({<br>        id         = string<br>        cidr_block = string<br>      })<br>      c = object({<br>        id         = string<br>        cidr_block = string<br>      })<br>    })<br>    tooling = object({<br>      id         = string<br>      cidr_block = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_session_manager_policy_arn"></a> [session\_manager\_policy\_arn](#input\_session\_manager\_policy\_arn) | SessionManager接続権限を含んだIAMポリシーARN (Bastionインスタンスロールへアタッチ) | `string` | n/a | yes |
| <a name="input_tf"></a> [tf](#input\_tf) | Terraformアプリケーション情報 | <pre>object({<br>    name          = string<br>    shortname     = string<br>    env           = string<br>    fullname      = string<br>    fullshortname = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | NATインスタンスを起動するVPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_a"></a> [instance\_a](#output\_instance\_a) | NAT instance (AZ: A) |
| <a name="output_instance_c"></a> [instance\_c](#output\_instance\_c) | NAT instance (AZ: C only when multi AZ enabled) |
| <a name="output_instance_role"></a> [instance\_role](#output\_instance\_role) | NAT instance IAM Role |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | NAT instance security group |
<!-- END_TF_DOCS -->    
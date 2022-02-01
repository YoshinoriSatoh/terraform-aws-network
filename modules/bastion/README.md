<!-- BEGIN_TF_DOCS -->
# Terraform AWS Bastion Module

プライベートサブネットに配置されているRDS等への接続時に使用するBastion（踏み台）インスタンスを構築します。
AMIはデフォルトでAmazonLinux2(Arm64)の最新版を使用します。
BastionインスタンスへはSessionManagerを使用して接続する想定であるため、SessionManger接続権限を含んだIAMポリシーARNを渡す必要があります。

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
| [aws_iam_instance_profile.bastion](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.bastion](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.bastion_attach_AmazonSSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.bastion_attach_session_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/instance) | resource |
| [aws_key_pair.bastion](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/key_pair) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/resources/security_group) | resource |
| [aws_ami.bastion](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.74.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance"></a> [instance](#input\_instance) | Bastionインスタンス設定 | <pre>object({<br>    ami_name_filter = string<br>    instance_type   = string<br>  })</pre> | <pre>{<br>  "ami_name_filter": "amzn2-ami-hvm-*-arm64-gp2",<br>  "instance_type": "t4g.nano"<br>}</pre> | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Bastionインスタンスのキーペアのパブリックキーファイルパス. 呼び出し側でSSHキーを生成の上、ファイルパスを指定してください。 | `string` | `"./key_pairs/bastion.pub"` | no |
| <a name="input_session_manager_policy_arn"></a> [session\_manager\_policy\_arn](#input\_session\_manager\_policy\_arn) | SessionManager接続権限を含んだIAMポリシーARN (Bastionインスタンスロールへアタッチ) | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Bastionインスタンスを起動するサブネットID | `string` | n/a | yes |
| <a name="input_tf"></a> [tf](#input\_tf) | Terraformアプリケーション情報 | <pre>object({<br>    name          = string<br>    shortname     = string<br>    env           = string<br>    fullname      = string<br>    fullshortname = string<br>  })</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Bastionインスタンスを起動するVPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance"></a> [instance](#output\_instance) | Bastion instance |
| <a name="output_instance_role"></a> [instance\_role](#output\_instance\_role) | Bastion instance IAM Role |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | Bastion instance security group |
<!-- END_TF_DOCS -->    
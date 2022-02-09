variable "tf" {
  description = "Terraformアプリケーション情報"
  type = object({
    name          = string
    shortname     = string
    env           = string
    fullname      = string
    fullshortname = string
  })
}

variable "in_development" {
  description = "Terraform構築検証モード（各種リソースの削除保護が無効化されます）"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "Bastionインスタンスを起動するVPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Bastionインスタンスを起動するサブネットID"
  type        = string
}

variable "ami_name_filter" {
  description = "BastionインスタンスAMIを選択する際のフィルタ（一致するものの中で最新のAMIを使用）"
  type        = string
  default     = "amzn2-ami-hvm-*-arm64-gp2"
}

variable "instance_type" {
  description = "Bastionインスタンスタイプ"
  type        = string
  default     = "t4g.nano"
}

variable "public_key_path" {
  description = "Bastionインスタンスのキーペアのパブリックキーファイルパス. 呼び出し側でSSHキーを生成の上、ファイルパスを指定してください。"
  type        = string
  default     = "./key_pairs/bastion.pub"
}

variable "session_manager_policy_arn" {
  description = "SessionManager接続権限を含んだIAMポリシーARN (Bastionインスタンスロールへアタッチ)"
  type        = string
}

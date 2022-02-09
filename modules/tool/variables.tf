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
  description = "toolインスタンスを起動するVPC ID"
  type        = string
}

variable "subnet_id" {
  description = "toolインスタンスを起動するサブネットID"
  type        = string
}

variable "ami" {
  description = "インスタンスAMI(省略時はAmazonLinux2(Arm64)の最新版を使用)"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "インスタンスタイプ"
  type        = string
  default     = "t4g.nano"
}

variable "enable_spot_instance" {
  description = "スポットインスタンスを使用する"
  type        = bool
  default     = true
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

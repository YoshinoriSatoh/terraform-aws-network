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
  description = "NATインスタンスを起動するVPC ID"
  type        = string
}

variable "public_subnets" {
  description = "NATインスタンスを起動するサブネットID"
  type = object({
    a = object({
      id = string
    })
    c = object({
      id = string
    })
  })
}

variable "routing_subnets" {
  description = "NATルーティング対象のサブネットID"
  type = object({
    private = object({
      a = object({
        id         = string
        cidr_block = string
      })
      c = object({
        id         = string
        cidr_block = string
      })
    })
  })
}

variable "ami" {
  description = "NATインスタンスAMI"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "NATインスタンスタイプ"
  type        = string
  default     = "t3.nano"
}

variable "multi_az" {
  description = "NATインスタンスの冗長化"
  type        = bool
  default     = false
}

# variable "public_key_path" {
#   description = "Bastionインスタンスのキーペアのパブリックキーファイルパス. 呼び出し側でSSHキーを生成の上、ファイルパスを指定してください。"
#   type        = string
#   default     = "./key_pairs/nat_instance.pub"
# }

variable "session_manager_policy_arn" {
  description = "SessionManager接続権限を含んだIAMポリシーARN (Bastionインスタンスロールへアタッチ)"
  type        = string
}

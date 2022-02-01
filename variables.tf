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

variable "vpc" {
  description = "VPC設定"
  type = object({
    cidr_block = string
  })
  default = {
    cidr_block = "10.0.0.0/16"
  }
}

variable "subnets" {
  description = "サブネット設定"
  type = object({
    public = object({
      a = object({
        cidr_block = string
      })
      c = object({
        cidr_block = string
      })
    })
    application = object({
      a = object({
        cidr_block = string
      })
      c = object({
        cidr_block = string
      })
    })
    database = object({
      a = object({
        cidr_block = string
      })
      c = object({
        cidr_block = string
      })
    })
    tooling = object({
      cidr_block = string
    })
  })
  default = {
    public = {
      a = {
        cidr_block = "10.0.0.0/22"
      }
      c = {
        cidr_block = "10.0.4.0/22"
      }
    }
    application = {
      a = {
        cidr_block = "10.0.12.0/22"
      }
      c = {
        cidr_block = "10.0.16.0/22"
      }
    }
    database = {
      a = {
        cidr_block = "10.0.24.0/22"
      }
      c = {
        cidr_block = "10.0.28.0/22"
      }
    }
    tooling = {
      cidr_block = "10.0.36.0/22"
    }
  }
}

variable "bastion_enabled" {
  description = "Bastionインスタンスの有無を指定します"
  type = bool
  default = false
}

variable "nat_enabled" {
  description = "NAT構成の有無を指定します"
  type = bool
  default = false
}

variable "nat_type" {
  description = "NAT構成を有効化する場合に、NATインスタンス or NATゲートウェイを指定します"
  type = string
  default = "instance"

  validation {
    condition = contains(["instance", "gateway"], var.nat_type)
    error_message = "Allowed values for nat_type are \"instance\" or \"gateway\"."
  }
}

variable "nat_multi_az" {
  description = "NATインスタンス or ゲートウェイを冗長化します"
  type = bool
  default = false
}

variable "public_key_paths" {
  description = "Bastion/NATインスタンスのキーペアのパブリックキーファイルパス. 呼び出し側でSSHキーを生成の上、ファイルパスを指定してください。"
  type        = object({
    bastion = string
    nat = string
  })
  default = {
    bastion = "./key_pairs/bastion.pub"
    nat = "./key_pairs/nat_instance.pub"
  }
}

variable "session_manager_policy_arn" {
  description = "SessionManager接続権限を含んだIAMポリシーARN (Bastion/NATインスタンスロールへアタッチ)"
  type        = string
}

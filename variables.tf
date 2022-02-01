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

variable "multi_az" {
  description = "NATインスタンス/ゲートウェイを冗長化します（Bastionインスタンスは冗長化しません）"
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

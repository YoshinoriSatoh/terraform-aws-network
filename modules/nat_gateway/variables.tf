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

variable "multi_az" {
  description = "NATインスタンスの冗長化"
  type        = bool
  default     = false
}

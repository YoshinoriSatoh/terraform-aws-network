variable "tf" {
  type = object({
    name          = string
    shortname     = string
    env           = string
    fullname      = string
    fullshortname = string
  })
}

variable "vpc" {
  type = object({
    cidr_block = string
  })
  default = {
    cidr_block = "10.0.0.0/16"
  }
}

variable "subnets" {
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

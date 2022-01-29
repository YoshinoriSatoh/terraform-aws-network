# デフォルトリージョン
provider "aws" {
  default_tags {
    tags = {
      TfName = local.tf.name
      TfEnv  = local.tf.env
    }
  }
}


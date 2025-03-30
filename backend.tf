terraform {
  backend "s3" {
    bucket       = "wk7-terraform"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true // to avoid two persons to works on it at the same time
  }
}

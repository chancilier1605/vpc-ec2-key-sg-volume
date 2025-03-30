module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  name = "utc-appe"
  version = "5.79.0"
}
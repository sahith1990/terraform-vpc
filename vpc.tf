provider aws {
    region = var.region
}

terraform {
  backend "s3" {
    bucket = "ecommerce-terraform-state-files"
    key    = "terraform-vpc"
    region = "us-east-1"
  }
}

resource "aws_vpc" "ecommerce-vpc" {
    cidr_block        = var.vpc_cidr
    instance_tenancy  = "default"

    tags = {
      Name    =  "[Ecommerce]"
    }
}

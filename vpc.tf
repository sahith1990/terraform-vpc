provider aws {
    region = var.region
}

resource "aws_vpc" "ecommerce-vpc" {
    cidr_block        = var.vpc_cidr
    instance_tenancy  = "default"

    tags = {
      Name    =  "[Ecommerce]"
    }
}

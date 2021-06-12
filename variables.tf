variable "vpc_cidr" {
    description   = "Choose CIDR block for VPC"
    type          = string
    default       = "10.0.0.0/16"
}

variable "region" {
    description   = "Choose region for your stack"
    type          = string
    default       = "us-east-1"
}

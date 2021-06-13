resource "aws_subnet" "private" {
  count               = length(slice(local.az_names, 0 , 3))
  vpc_id              = aws_vpc.ecommerce-vpc.id
  cidr_block          = cidrsubnet(var.vpc_cidr, 8 , count.index + length(local.az_names))
  availability_zone   = local.az_names[count.index]

  tags = {
    Name = "[Ecommerce] Private - ${local.az_names[count.index]}"
  }
}


resource "aws_nat_gateway" "nat" {
  count             = length(slice(local.az_names, 0, 3))
  connectivity_type = "private"
  subnet_id         = local.pub_sub_ids[count.index]

  tags = {
    Name = "[Ecommerce] Private - ${local.az_names[count.index]}"
  }
}

resource "aws_route_table" "PrivateRouteTable" {
  count   = length(slice(local.az_names, 0, 3))
  vpc_id  = aws_vpc.ecommerce-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.nat_gateway_ids[count.index]
  }

  tags = {
    Name = "[Ecommerce] Private - ${local.az_names[count.index]}"
  }
}


resource "aws_route_table_association" "pri_sub_association" {
  count          = length(slice(local.az_names, 0 ,3))
  subnet_id      = local.private_sub_ids[count.index]
  route_table_id = local.route_table_ids[count.index]
}

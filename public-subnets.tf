locals {
    az_names    = data.aws_availability_zones.azs.names
    pub_sub_ids = aws_subnet.public.*.id
    private_sub_ids = aws_subnet.private.*.id
    nat_gateway_ids = aws_nat_gateway.nat.*.id
    route_table_ids = aws_route_table.PrivateRouteTable.*.id
}

resource "aws_subnet" "public" {
  count                     = length(slice(local.az_names, 0 ,3))
  vpc_id                    = aws_vpc.ecommerce-vpc.id
  cidr_block                = cidrsubnet(var.vpc_cidr, 8 , count.index)
  availability_zone         = local.az_names[count.index]
  map_public_ip_on_launch   = true

  tags = {
    Name = "[Ecommerce] Public - ${local.az_names[count.index]}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecommerce-vpc.id

  tags = {
    Name = "[Ecommerce]"
  }
}

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.ecommerce-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "[Ecommerce] Public"
  }
}

resource "aws_route_table_association" "pub_sub_association" {
  count          = length(slice(local.az_names, 0 ,3))
  subnet_id      = local.pub_sub_ids[count.index]
  route_table_id = aws_route_table.PublicRouteTable.id
}

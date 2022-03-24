locals {
  public_ip          = true
  availability_zone1 = var.az1
  availability_zone2 = var.az2
  availability_zone3 = var.az3
}




resource "aws_vpc" "main" {

  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = var.vpc-name
  }
}

# ------------------------------------------------------------------------


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw-name
  }
}


# ------------------------------------------------------------------------

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.priv_subnet-1
  availability_zone = local.availability_zone1

  tags = {
    "Name"                            = var.priv_subnet-1-name
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "shared"
  }
}




resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.priv_subnet-2
  availability_zone = local.availability_zone2

  tags = {
    "Name"                            = var.priv_subnet-2-name
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "shared"
  }
}


resource "aws_subnet" "private-subnet-3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.priv_subnet-3
  availability_zone = local.availability_zone3

  tags = {
    "Name"                            = var.priv_subnet-3-name
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "shared"
  }
}


# ------------------------------------------------------------------------


resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet-1
  availability_zone       = local.availability_zone1
  map_public_ip_on_launch = local.public_ip

  tags = {
    "Name"                       = var.public_subnet-3-name
    "kubernetes.io/cluster/demo" = "shared"
    "kubernetes.io/role/elb"     = 1
  }
}



resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet-2
  availability_zone       = local.availability_zone2
  map_public_ip_on_launch = local.public_ip

  tags = {
    "Name"                       = var.public_subnet-3-name
    "kubernetes.io/cluster/demo" = "shared"
    "kubernetes.io/role/elb"     = 1
  }
}


resource "aws_subnet" "public-subnet-3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet-3
  availability_zone       = local.availability_zone3
  map_public_ip_on_launch = local.public_ip

  tags = {
    "Name"                       = var.public_subnet-3-name
    "kubernetes.io/cluster/demo" = "shared"
    "kubernetes.io/role/elb"     = 1
  }
}

#------------------------------------------------------------------------

resource "aws_eip" "nat-gateway-ip" {
  vpc = true
  tags = {
    "Name" = var.eip
  }

  depends_on = [aws_internet_gateway.igw]
}

#------------------------------------------------------------------------

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-gateway-ip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = var.nat-gateway
  }

  depends_on = [aws_internet_gateway.igw]
}


#------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.igw.id
      nat_gateway_id             = ""
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = var.public-rt
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.nat-gateway.id
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = var.private-rt
  }
}

#------------------------------------------------------------------------

resource "aws_route_table_association" "private-subnet-association-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-subnet-association-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private-subnet-association-3" {
  subnet_id      = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.private.id
}


#------------------------------------------------------------------------


resource "aws_route_table_association" "public-subnet-association-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-subnet-association-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public.id
}



resource "aws_route_table_association" "public-subnet-association-3" {
  subnet_id      = aws_subnet.public-subnet-3.id
  route_table_id = aws_route_table.public.id
}


#------------------------------------------------------------------------


resource "aws_default_route_table" "igw-test" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

#------------------------------------------------------------------------








provider "aws" {
  region = var.aws-region
}

# ----------------------------CREATING A NEW VPC------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name"        = var.vpc-name
    Envinonment   : var.env
    createdby     : var.created_by
    client        : var.client
    provisionedby : var.provisioned
  }
}

# ----------------------------CREATING SUBNETS------------------------------------------------

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-1
  availability_zone = var.az1

  tags = {
    "Name"        = var.subnet-1-name
    Envinonment   : var.env
    createdby     : var.created_by
    client        : var.client
    provisionedby : var.provisioned
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-2
  availability_zone = var.az2

  tags = {
    "Name"        = var.subnet-2-name
    Envinonment   : var.env
    createdby     : var.created_by
    client        : var.client
    provisionedby : var.provisioned
  }
}

# ----------------------------CREATING A NEW INTERNET-GATEWAY--------------------------------------------

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name          = var.igw-name
    Envinonment   : var.env
    createdby     : var.created_by
    client        : var.client
    provisionedby : var.provisioned
  }
}

# ----------------------------CREATING PUBLIC ROUTE TABLE--------------------------------------------

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.terraform-us.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = var.public-rt
    Envinonment: var.env
    createdby: var.created_by
    client: var.client
    provisionedby: var.provisioned
  }

}

# ----------------------------ASSOCIATING PUBLIC SUBNETS TO PUBLIC ROUTE TABLE--------------------------------------------

resource "aws_route_table_association" "association" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route_table.id
}

# ----------------------------CREATING SECURITY GROUP---------------------------------------------------------------------

resource "aws_security_group" "ec2-security-group" {
  name   = var.sg-name  
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH for EC-2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }

egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ----------------------------CREATING PEM File---------------------------------------------------------------------

resource "tls_private_key" "sip-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "sip-key" {
  key_name   = var.key-name
  public_key = tls_private_key.sip-key.public_key_openssh
}

# ----------------------------CREATING EBS VOLUME---------------------------------------------------------------------

resource "aws_ebs_volume" "ebs-volume" {
  availability_zone = var.az1
  size              = var.ebs-size

  tags = {
    Name          = var.ebs-vol-name
    Envinonment   : var.env
    createdby     : var.created_by
    client        : var.client
    provisionedby : var.provisioned
  }
}


# ----------------------------CREATING EC2 INSTANCE---------------------------------------------------------------------

resource "aws_instance" "instance" {

  ami           = var.ami
  instance_type = var.instance-type     
  vpc_security_group_ids = [
    "${aws_security_group.ec2-security-group.id}"
  ]
  subnet_id                   = aws_subnet.subnet-1.id
  key_name                    = aws_key_pair.sip-key.key_name
  associate_public_ip_address = true
  availability_zone           = var.az1
  
  security_groups = [
    aws_security_group.ec2-security-group.id
  ]


  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
  }

  tags = {
    Name          = var.ec2-name
    Envinonment   : var.env
    createdby     : var.created_by
    client        : var.client
    provisionedby : var.provisioned

  }


  depends_on = [aws_security_group.ec2-security-group]
}

# ----------------------------EC2 AND EBS VOlUME ATTACHMENT---------------------------------------------------------------------

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs-volume.id
  instance_id = aws_instance.instance.id
}

# ----------------------------ALLOCATING AN ELASTIC IP---------------------------------------------------------------------

resource "aws_eip" "elastic-ip" {
  instance = aws_instance.instance.id
  vpc = true
}

output "ec2instance" {
  value = aws_instance.instance.public_ip
}



# output "ssh_key" {
#   description = "ssh key generated by terraform"
#   value       = tls_private_key.sip-key.private_key_pem
#   sensitive   = true
# }


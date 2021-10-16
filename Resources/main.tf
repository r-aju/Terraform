
#------------------------- CREATING IAM USER-----------------------#
resource "aws_iam_user" "creating-user" {
  name = var.user_name
  tags = {
    # "Name" = "terraform-test"
    "Purpose" = "Testing"
  }
}


#------------------------- CREATING NEW POLICY-----------------------#
resource "aws_iam_policy" "policy-for-user" {
  name = var.policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "s3:ListAllMyBuckets",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#------------------------- ATTACHING POLICY-----------------------#

resource "aws_iam_user_policy_attachment" "kanaka-admin-access" {

  user       = aws_iam_user.creating-user.name
  policy_arn = aws_iam_policy.policy-for-user.arn

}

#-------------------------CREATING NEW GROUP-----------------------#

resource "aws_iam_group" "terraform-group" {
  name = var.new_group_name
}

#------------------------- ADDING USER TO GROUP-----------------------#

resource "aws_iam_group_membership" "add-user" {
  name = "existing group name"
  users = [
    aws_iam_user.creating-user.name
  ]
  group = aws_iam_group.terraform-group.name
}

#------------------------- CREATING VPC-----------------------#

resource "aws_vpc" "terraform-test" {
  cidr_block       = var.cidr-for-vpc
  instance_tenancy = var.instance-tentancy-for-vpc

  tags = {
    Name       = var.vpc_name
    Team       = "DevOps"
    Created_by = "Kanakaraju"
    Purpose    = "Terraform_testing"
  }

}

#------------------------- CREATING SECURITY GROUP-----------------------#

resource "aws_security_group" "terraform_private_sg" {
  #   description = "Allow limited inbound external traffic"
  vpc_id = aws_vpc.terraform-test.id
  name   = var.security_group_name


  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "private-sg for ec-2"
  }
}

#------------------------- ATTACHING SUBNET-----------------------#

resource "aws_subnet" "terraform-subnet_1" {
  vpc_id            = aws_vpc.terraform-test.id
  cidr_block        = var.cidr-for-vpc
  availability_zone = var.availability_zone

  tags = {
    Name = "terraform-subnet_1"
  }
}

#------------------------- CREATING NEW EBS VOLUME-----------------------#

resource "aws_ebs_volume" "new-ebs" {
  availability_zone = var.availability_zone
  size              = var.ebs_size
  type              = var.ebs_type
}


#------------------------- CREATING NEW EC2 INSTANCE-----------------------#

resource "aws_instance" "terraform-test" {
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  vpc_security_group_ids = [
    "${aws_security_group.terraform_private_sg.id}"
  ]
  subnet_id = aws_subnet.terraform-subnet_1.id
  # key_name               = "terraform"
  availability_zone = var.availability_zone


  root_block_device {
    volume_type = var.ebs_type
    volume_size = 10
  }

  tags = {
    Name        = "terraform_ec2"
    Environment = "test"
    Project     = "DEMO-TERRAFORM"
    Team        = "DevOps"
    Created_by  = "Kanakaraju"
    Purpose     = "Terraform_testing"

  }
}

#------------------------- ATTACHING THE CREATING VOLUME-----------------------#

resource "aws_volume_attachment" "ebs_att" {
  device_name = var.device_spec
  volume_id   = aws_ebs_volume.new-ebs.id
  instance_id = aws_instance.terraform-test.id
}



#------------------------- NEW S3 BUCKET-----------------------#

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = var.acl_policy

  tags = {
    Environment = "DevOps"
  }
}








# resource "tls_private_key" "pk" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "kp" {
#   key_name   = "myKey"       # Create "myKey" to AWS!!
#   public_key = tls_private_key.pk.public_key_openssh
# }

# output "priv-key" {
#     sensitive = true
#     value = "${tls_private_key.pk.private_key_pem}"

# }






# ## Create VPC ##
# resource "aws_vpc" "terraform-vpc" {
#   cidr_block       = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   tags = {
#     Name = "terraform-demo-vpc"
#     Team = "DevOps"
#     Created_by = "Kanakaraju"
#     Purpose = "Terraform_testing"
#   }
# }

# output "aws_vpc_id" {
#   value = "${aws_vpc.terraform-vpc.id}"
# }

# ## Security Group##
# resource "aws_security_group" "terraform_private_sg" {
#   description = "Allow limited inbound external traffic"
#   vpc_id      = "${aws_vpc.terraform-vpc.id}"
#   name        = "terraform_ec2_private_sg"

#   ingress {
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 22
#     to_port     = 22
#   }

#  egress {
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 0
#     to_port     = 0
#   }

#   tags = {
#     Name = "ec2-private-sg"
#   }
# }

# output "aws_security_gr_id" {
#   value = "${aws_security_group.terraform_private_sg.id}"
# }

# ## Create Subnets ##
# resource "aws_subnet" "terraform-subnet_1" {
#   vpc_id     = "${aws_vpc.terraform-vpc.id}"
#   cidr_block = "172.16.10.0/24"
#   availability_zone = "ap-south-1"

#   tags = {
#     Name = "terraform-subnet_1"
#   }
# }

# output "aws_subnet_subnet_1" {
#   value = "${aws_subnet.terraform-subnet_1.id}"
# }

# resource "aws_instance" "terraform_wapp" {
#     ami = "ami-0a23ccb2cdd9286bb"
#     instance_type = "t2.micro"
#     vpc_security_group_ids =  ["${aws_security_group.terraform_private_sg.id}" ]
#     subnet_id = "${aws_subnet.terraform-subnet_1.id}"
#     key_name               = "terraform-test.pem"
#     count         = 1
#     associate_public_ip_address = true
#     tags = {
#       Name              = "terraform_ec2_wapp_awsdev"
#       Environment       = "test"
#       Project           = "DEMO-TERRAFORM"
#       Team = "DevOps"
#       Created_by = "Kanakaraju"
#       Purpose = "Terraform_testing"

#     }
# }

# output "instance_id_list"     { value = ["${aws_instance.terraform_wapp.*.id}"] }
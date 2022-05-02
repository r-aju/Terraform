#---------------------------COMMON TAGS VARIABLES--------------------------------------------#
variable "env" {
  description = "The Environment for tags"
  type        = string
}

variable "created_by" {
  description = "The created by for tags"
  type        = string
}

variable "client" {
  description = "The client name for tags"
  type        = string
}

variable "provisioned" {
  description = "The tool used for provisioning infrastructure"
  type        = string
}


#---------------------------VPC & NETWORK VARIABLES--------------------------------------------#

variable "vpc-name" {
  description = "VPC Name"
  type        = string
}

variable "vpc-cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "subnet-1-name" {
  description = "Private subnet-1 name"
  type        = string
}

variable "subnet-2-name" {
  description = "Private subnet-2 name"
  type        = string
}

variable "subnet-1" {
description = "Private subnet-1 range"
}


variable "subnet-2" {
description = "Private subnet-2 range"
}

variable "igw-name" {
  description = "Internet Gateway name"
  type        = string
}

variable "public-rt" {
  description = "Public route table"
  type        = string
}

variable "sg-name" {
  description = "Skitll security group"
  type        = string
}

variable "public-rt" {
  description = "Public route table"
  type        = string
}

#---------------------------EC2 VARIABLES--------------------------------------------#
variable "ebs-vol-name" {
    description = "EBS Volume Name"
    type = string
  
}

variable "ebs-size" {
    description = "EBS Volume Size"
    type = number
}


variable "ami" {
    description = "AMI type for the EC2"
    type = string
}

variable "instance-type" {
  description = "Instance type"
    type = string
}


variable "ec2-name" {
  description = "Instance Name"
    type = string
}

variable "key-name" {
    description = "Pem file key Name"
    type = string
  
}

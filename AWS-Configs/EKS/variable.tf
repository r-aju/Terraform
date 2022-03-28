variable "aws-region" {
  description = "AWS Region"
  type        = string
}

variable "az1" {
  description = "Availability Zone 1"
  type        = string
}

variable "az2" {
  description = "Availability Zone 2"
  type        = string
}

variable "az3" {
  description = "Availability Zone 2"
  type        = string
}



variable "vpc-name" {
  description = "VPC Name"
  type        = string
}

variable "vpc-cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "igw-name" {
  description = "Internet Gateway name"
  type        = string
}



variable "priv_subnet-1-name" {
  description = "Private subnet-1 name"
  type        = string
}

variable "priv_subnet-2-name" {
  description = "Private subnet-2 name"
  type        = string
}

variable "priv_subnet-3-name" {
  description = "Private subnet-3 name"
  type        = string
}




variable "priv_subnet-1" {
  description = "Private subnet-1 range"
  type        = string
}

variable "priv_subnet-2" {
  description = "Private subnet-2 range"
  type        = string
}

variable "priv_subnet-3" {
  description = "Private subnet-3 range"
  type        = string
}




variable "public_subnet-1" {
  description = "Public subnet-1 range"
  type        = string
}

variable "public_subnet-2" {
  description = "Public subnet-2 range"
  type        = string
}

variable "public_subnet-3" {
  description = "Public subnet-3 range"
  type        = string
}



variable "public_subnet-1-name" {
  description = "Public subnet-1 range"
  type        = string
}


variable "public_subnet-2-name" {
  description = "Public subnet-2 range"
  type        = string
}

variable "public_subnet-3-name" {
  description = "Public subnet-3 range"
  type        = string
}

variable "eip" {
  description = "Elastic IP for private subnets"
  type        = string
}

variable "nat-gateway" {
  description = "NAT Gateway for private subnets"
  type        = string
}

variable "public-rt" {
  description = "Public route table"
  type        = string
}


variable "private-rt" {
  description = "Private route table"
  type        = string
}

variable "eks-role-name" {
  description = "Role name for EKS Cluster"
  type        = string
}


variable "cluster-name" {
  description = " EKS Cluster name"
  type        = string
}

variable "cluster-version" {
  description = " EKS Cluster version"
  type        = string
}


variable "node-group-role-name" {
  description = "Role name for EKS Node Groups"
  type        = string
}

variable "capacity" {
  description = "Setting weather it's ONDEMAND or SPOT Type of Instances"
  type        = string
}

variable "ami_types" {
  description = "Setting the AMI Type for the Instances ex:AL2_x86_64 etc etc"
  type        = string
}

variable "instance_type" {
  description = "Instance types ex:t2.micro, t3.medium etc etc"
  
}
variable "desired_nodes" {
type = number
description = "The desired number of nodes in the Node Group"
}

variable "max_nodes" {
type = number
description = "The maximum number of nodes in the Node Group"
}

variable "min_nodes" {
type = number
description = "The minimun number of nodes in the Node Group"
}

variable "disk" {
  description = "The storage for the Nodes"
  type        = number
}











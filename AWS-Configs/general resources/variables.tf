variable "aws_region" {
  type        = string
  description = " Please enter the region"
}

variable "user_name" {
  type        = string
  description = " Please enter the username to create"
}

variable "policy_name" {
  type        = string
  description = " Please enter the policy"
}

variable "new_group_name" {
  type        = string
  description = " Please enter the new group name"
}

variable "vpc_name" {
  type        = string
  description = " Please enter Name for new VPC"
}


variable "cidr-for-vpc" {
  type        = string
  description = " Please enter CIDR range of new VPC"
}

variable "instance-tentancy-for-vpc" {
  type        = string
  description = " Please enter the type of tenancy for VPC"
}

variable "security_group_name" {
  type        = string
  description = " Please enter the security group name"
}


variable "bucket_name" {
  type        = string
  description = " Please enter the name of S-3 bucket"
}

variable "acl_policy" {
  type        = string
  description = " Please enter the policy for s-3 bucket"
}

variable "aws_ami" {
  type        = string
  description = " Please enter the AWS AMI"
}

variable "aws_instance_type" {
  type        = string
  description = " Please enter the Instance type"
}


variable "availability_zone" {
  type        = string
  description = " Please enter the Availability zone"
}

variable "device_spec" {
  type        = string
  description = " Please enter the device specification"
}

variable "ebs_size" {
  type        = number
  description = " Please enter volume size"
}



variable "ebs_type" {
  type        = string
  description = " Please enter the ebs type gp2 or gp3"
}






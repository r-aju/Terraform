output "aws_vpc_id" {
  value = aws_vpc.terraform-test.id
}

output "aws_security" {
  value = aws_security_group.terraform_private_sg.id
}

output "aws_subnet_subnet_1" {
  value = aws_subnet.terraform-subnet_1.id
}

output "s3-bucket-name" {
  value = aws_s3_bucket.bucket.id
}

output "instance_id_list" {
  value = ["${aws_instance.terraform-test.*.id}"]

}



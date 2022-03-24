resource "aws_iam_user" "creating-user" {
  name = var.user
  tags = {
    "Purpose" = "New User"
  }
}


resource "aws_iam_user_login_profile" "new-user" {
  user    = aws_iam_user.creating-user.name
  pgp_key = file("public.gpg")          ## gpg key must be generated to encrypt
}



resource "aws_iam_group_membership" "add-user" {
  name = "existing group name"
  users = [
        aws_iam_user.creating-user.name
          ]
  group = var.group_name
}

output "password" {
  value = aws_iam_user_login_profile.new-user.encrypted_password
}





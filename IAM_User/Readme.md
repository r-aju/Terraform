## Create a username with password




### Create GPG Keys using the folloing commands or create keys using keybase

```
gpg --generate-key
gpg --export | base64 > public.gpg

```

### After this run terraform commands

```
terraform init
terraform validate
terraform plan -var-file="testing.tfvars"
terraform apply -var-file="testing.tfvars"
```

### To decrypt the password

```
export $(terraform output | sed 's/ //g' | sed 's/"//g')    # So you get a bash variable called `password`
echo $password | base64 -d | gpg -d
```

#---------------------------COMMON TAGS--------------------------------------------#

env          = "<prod, staging etc etc>"                        
created_by   = "<team-name>"                                      
client       = "***********"
provisioned  = "terraform"

#--------------------------- VPC Related details--------------------------------------------#

vpc-name = "test-vpc"
vpc-cidr = "110.***********"

#--------------------------- Subnet Related details--------------------------------------------#
priv_subnet-1-name   = "test-private-subnet-1"
priv_subnet-1        = "110.***********"
priv_subnet-2-name   = "test-private-subnet-2"
priv_subnet-2        = "110.**********"


public_subnet-1-name = "test-public-subnet-1"
public_subnet-1      = "110.**********"
public_subnet-2-name = "test-public-subnet-2"
public_subnet-2      = "110.*********"

igw-name             = "test-igw"
public-rt            = test-public-rt"
sg-name              = "test-sg"

#---------------------------REGION & ZONES--------------------------------------------#
aws-region = "ap-south-1"                                 
az1        = "ap-south-1a"
az2        = "ap-south-1b"                            
az3        = "ap-south-1c"                       

#---------------------------EC2 INSTANCE DETAILS--------------------------------------------#

ebs-vol-name  = "test-ebs-volume"                
ebs-size      = "10"                                     

ami           = "ami-************"
instance-type = "t2.micro.....t3.medium etc etc"                                
ec2-name      = "test-vm"                 
key-name      = "test-ssh-key"                

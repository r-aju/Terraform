aws-region = "us-east-1"
az1        = "us-east-1a"
az2        = "us-east-1b"
az3        = "us-east-1c"



#--------------------------- VPC Related details--------------------------------------------#
vpc-name = "terraform-test"
vpc-cidr = "100.45.48.0/20"
igw-name = "terraform-internet-gateway"




#--------------------------- Subnet Related details--------------------------------------------#
priv_subnet-1-name = "terraform-private-subnet-1a"
priv_subnet-1      = "100.45.48.0/22"
priv_subnet-2-name = "terraform-private-subnet-2a"
priv_subnet-2      = "100.45.56.0/23"
priv_subnet-3-name = "terraform-private-subnet-3a"
priv_subnet-3      = "100.45.60.0/23"



public_subnet-1-name = "terraform-public-1a"
public_subnet-1      = "100.45.52.0/22"
public_subnet-2-name = "terraform-public-1b"
public_subnet-2      = "100.45.58.0/23"
public_subnet-3-name = "terraform-public-1c"
public_subnet-3      = "100.45.62.0/23"




#--------------------------- Network- Route-table--------------------------------------------#
eip         = "terraform-nat-ip"
nat-gateway = "terraform-association"
public-rt   = "terraform-public-route-table"
private-rt  = "terraform-private-route-table"




#--------------------------- EKS Related details ---------------------------------------------#

eks-role-name   = "terraform-testing"
cluster-name    = "demo-cluster"
cluster-version = "1.21"


node-group-role-name = "terraform-ng-testing"
ng-name              = "terraform-nodes"

capacity = "ON_DEMAND"
ami_types = "AL2_x86_64"
instance_type = ["m5.2xlarge"]
disk     = 40
desired_nodes = 2
max_nodes = 2
min_nodes = 1






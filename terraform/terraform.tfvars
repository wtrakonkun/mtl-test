region="ap-southeast-1"

app_name = "eks-app-demo"

cidr = "10.11.0.0/16"
availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
public_subnets     = ["10.11.100.0/24", "10.11.101.0/24"]
private_subnets    = ["10.11.0.0/24", "10.11.1.0/24"]
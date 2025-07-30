#EC2

aws_region = "us-east-2"
ami_id = "ami-0c55b159cbfafe1f0"
instance_type = "t2.micro"
ec2_tag = "uat-TerraformEC2Instance"

# Backend file variables
# s3_bucket = "terraform-s3-platformatory"
# dynamodb_table = "terraform-lock-table"
# s3_path = "terraform/state"

##vpc
cidr_block = "10.0.0.0/16"
vpc_tag_name = "uat-TerraformVPC"   
public_subnet_tag = "uat-TerraformPublicSubnet"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_tag = "uat-TerraformPrivateSubnet"
private_subnet_cidr = "10.0.2.0/24"
route_cidr_block = "0.0.0.0/0"


#####   ECR 

name_of_repository = "uat-my-ecr-repo"
tag_setting = "MUTABLE"
scan_on_push = true


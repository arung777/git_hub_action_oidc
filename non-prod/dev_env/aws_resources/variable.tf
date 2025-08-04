######  EC2
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string 
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string  
}

variable "ec2_tag" {
  description = "Tag to assign to the EC2 instance"
  type        = string
}

# variable "aws_access_key" {
#   description = "AWS access key for authentication"
#   type        = string
#   sensitive   = true  
# }

# variable "secret_key" {
#   description = "AWS secret key for authentication"
#   type        = string
#   sensitive   = true
# }



######  Backend file variables
# variable "s3_bucket" {
#   description = "The S3 bucket for Terraform state"
#   type        = string
#   default     = "terraform-s3-platformatory"
# }
# variable "dynamodb_table" {
#   description = "The DynamoDB table for Terraform state locking"
#   type        = string
#   default     = "terraform-lock-table"
# }
# variable "s3_path" {
#   description = "The S3 key for Terraform state"
#   type        = string
#   default     = "terraform/state"
# }



####  vpc

# variable "aws_region" {
#   description = "The AWS region to deploy resources in"
#   type        = string 
# }

# variable "vpc_tag_name" {
#   description = "Tag to assign to the VPC"
#   type        = string 
# }

# variable "public_subnet_tag" {
#   description = "Tag to assign to the public subnet"
#   type        = string 
  
# }

# variable "route_cidr_block" {
#   description = "CIDR block for the route table"
#   type        = string
  
# }
# variable "private_subnet_tag" {
#   description = "Tag to assign to the private subnet"
#   type        = string 
# }

# variable "aws_access_key" {
#   description = "AWS access key for authentication"
#   type        = string
#   sensitive   = true  
# }

# variable "secret_key" {
#   description = "AWS secret key for authentication"
#   type        = string
#   sensitive   = true
# }

# variable "cidr_block" {
#     description = "CIDR block for the VPC"
#     type        = string
# }

# variable "public_subnet_cidr" {
#     description = "CIDR block for the public subnet"
#     type        = string
# }

# variable "private_subnet_cidr" {
#     description = "CIDR block for the private subnet"
#     type        = string
# }





######  ECR

# variable "aws_region" {
#   description = "The AWS region to deploy resources in"
#   type        = string 
# }

variable "name_of_repository" {
  description = "The name of the ECR repository"
  type        = string
}

variable "tag_setting" {
  description = "Tag to assign to the EC2 instance"
  type        = string
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
}

# variable "aws_access_key" {
#   description = "AWS access key for authentication"
#   type        = string
#   sensitive   = true  
# }
#

# variable "secret_key" {
#   description = "AWS secret key for authentication"
#   type        = string
#   sensitive   = true
# }



#### EKS vpc  
variable "vpc_cidr" {
  description = "CIDR block of the created VPC"
  type        = string
  default = "10.0.0.0/16"
}


### EKS 
variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.27"
}


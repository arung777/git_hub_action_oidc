
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string 
}

variable "vpc_tag_name" {
  description = "Tag to assign to the VPC"
  type        = string 
}

variable "public_subnet_tag" {
  description = "Tag to assign to the public subnet"
  type        = string 
  
}

variable "route_cidr_block" {
  description = "CIDR block for the route table"
  type        = string
  
}
variable "private_subnet_tag" {
  description = "Tag to assign to the private subnet"
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

variable "cidr_block" {
    description = "CIDR block for the VPC"
    type        = string
}

variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    type        = string
}

variable "private_subnet_cidr" {
    description = "CIDR block for the private subnet"
    type        = string
}


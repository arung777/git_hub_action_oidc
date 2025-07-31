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




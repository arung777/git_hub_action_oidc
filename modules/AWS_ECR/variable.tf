variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string 
}

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
  default     = true
}

variable "aws_access_key" {
  description = "AWS access key for authentication"
  type        = string
  sensitive   = true  
}

variable "secret_key" {
  description = "AWS secret key for authentication"
  type        = string
  sensitive   = true
}




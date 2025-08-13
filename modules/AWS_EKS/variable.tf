variable "region" {
  type        = string
  description = "AWS region"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the EKS VPC"
}

variable "vpc_name" {
type = string 
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "eks_version" {
  type        = string
  description = "EKS control plane version"
}

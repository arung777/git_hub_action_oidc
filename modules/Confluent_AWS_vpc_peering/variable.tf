variable "environment_name" {
  description = "The display name of the environment"
  type        = string
  default = "default"
}

variable "confluent_cloud_api_key" {
    description = "Confluent Cloud API key for authentication"
    type        = string
    sensitive   = true
}

variable "confluent_cloud_api_secret" {
    description = "Confluent Cloud API secret for authentication"
    type        = string
    sensitive   = true
}

variable "network_details" {
  description = "Details of the network for the environment"
  type = object({
    display_name      = string
    cloud             = string
    region            = string
    cidr              = string
    connection_types  = list(string)
  })
}


variable "confluent_aws_peering_details" {
  description = "Details of the AWS VPC peering(s) in the environment"
  type = list(object({
    aws_account         = string
    aws_customer_region = string
    aws_routes          = list(string)
    aws_vpc             = string
  }))
}
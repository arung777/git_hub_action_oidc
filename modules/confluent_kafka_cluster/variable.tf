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

variable "availability_zone" {
  description = "The availability zone for the Kafka cluster"
  type        = string
}

variable "cloud_provider" {
  description = "The cloud provider for the Kafka cluster"
  type        = string
}

variable "region" {
  description = "The region for the Kafka cluster"
  type        = string
}
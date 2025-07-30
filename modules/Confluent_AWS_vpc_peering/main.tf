
resource "confluent_network" "aws-peering" {
  display_name     = var.network_details.display_name
  cloud            = var.network_details.cloud
  region           = var.network_details.region
  cidr             = var.network_details.cidr
  connection_types = var.network_details.connection_types
  environment {
    id = var.environment_name
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_peering" "aws" {
  display_name = "AWS Peering"
  aws {
    account         = var.confluent_aws_peering_details[0].aws_account
    vpc             = var.confluent_aws_peering_details[0].aws_vpc
    routes          = var.confluent_aws_peering_details[0].aws_routes
    customer_region = var.confluent_aws_peering_details[0].aws_customer_region
  }
  environment {
    id = var.environment_name
  }
  network {
    id = confluent_network.aws-peering.id
  }

  lifecycle {
    prevent_destroy = true
  }
}


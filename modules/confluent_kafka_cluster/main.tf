resource "confluent_environment" "development" {
  display_name = var.environment_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_kafka_cluster" "Terraform" {
  display_name = "basic_kafka_cluster"
  availability = var.availability_zone
  cloud        = var.cloud_provider
  region       = var.region
  basic {
  }

  environment {
    id = confluent_environment.development.id
  }

  lifecycle {
    prevent_destroy = true
  }
}
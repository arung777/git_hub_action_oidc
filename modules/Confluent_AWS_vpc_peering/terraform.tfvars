
  environment_name = "default"
  network_details = {
    display_name     = "network details of the confluent environment"
    cloud            = "AWS"
    region           = "ap-southeast-1"
    connection_types = ["PEERING"]
    cidr             = "10.10.0.0/16"
  }
  confluent_aws_peering_details = [
    {
      display_name        = "fist vpc peering details"
      aws_account         = "242201309386"
      aws_vpc             = "vpc-0ae450d7384e872e1"
      aws_routes          = ["10.0.0.0/16"]
      aws_customer_region = "us-east-2"
    }
  ]



terraform {
    backend "s3" {
        bucket         = "terraform-s3-platformatory"
        key            = "terraform/state"
        region         = "us-east-2"
        dynamodb_table = "terraform-lock-table"
        encrypt        = true   
        
    }
}
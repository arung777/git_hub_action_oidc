data "aws_instance" "terraform_ec2_instance" {
  instance_id = aws_instance.terraform_ec2_instance.id
  filter {
    name   = "tag:Name"
    values = ["Terraform EC2 Instance"]
  }
  # filter {
  #   name   = "instance-state-name"
  #   values = ["running"]
  # }

}


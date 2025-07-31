data "aws_instance" "terraform_ec2_instance" {
  instance_id = aws_instance.terraform_ec2_instance.id
  filter {
    name   = "tag:Name"
    values = [var.ec2_tag]
  }
  # filter {
  #   name   = "instance-state-name"
  #   values = ["running"]
  # }

}


resource "aws_instance" "terraform_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.ec2_tag
  }
}





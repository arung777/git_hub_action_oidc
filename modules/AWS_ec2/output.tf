output "public_ip" {
  value = aws_instance.terraform_ec2_instance.public_ip
  description = "value of the public IP address of the created instance"
}
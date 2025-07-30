output "public_ip" {
  value = data.aws_instance.terraform_ec2_instance.public_ip
  description = "value of the public IP address of the created instance"
}

output "instance_id" {
  value = data.aws_instance.terraform_ec2_instance.id
  description = "value of the instance ID of the created instance"
  
}
module "aws_instance" {
    source = "../../../modules/AWS_ec2"

    aws_region       = var.aws_region
    instance_type    = var.instance_type
    ami_id           = var.ami_id
    ec2_tag          = var.ec2_tag
    # aws_access_key   = var.aws_access_key
    # secret_key       = var.secret_key
}

output "public_ip" {
    value = module.aws_instance.public_ip
    description = "value of the public IP address of the created instance"
}
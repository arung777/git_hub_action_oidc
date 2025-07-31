module "myvpc" {
    source = "../../../modules/AWS_vpc"

    aws_region          = var.aws_region
    vpc_tag_name        = var.vpc_tag_name
    public_subnet_tag   = var.public_subnet_tag
    route_cidr_block    = var.route_cidr_block
    private_subnet_tag  = var.private_subnet_tag
    cidr_block          = var.cidr_block
    public_subnet_cidr  = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    # aws_access_key      = var.aws_access_key
    # secret_key          = var.secret_key
    
}

output "vpc_cidr_block" {
    value       = module.myvpc.vpc_cidr_block
    description = "CIDR block of the created VPC"
}
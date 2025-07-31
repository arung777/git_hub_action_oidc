output "vpc_cidr_block" {
  value = data.aws_vpc.myvpc.cidr_block
  description = "CIDR block of the VPC fetched from the data source"
}

output "vpc_id" {
  value = data.aws_vpc.myvpc.id
  description = "ID of the VPC fetched from the data source"
}
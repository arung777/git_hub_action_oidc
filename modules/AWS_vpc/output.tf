output "vpc_cidr_block" {
  value = data.aws_vpc.myvpc.cidr_block
  description = "CIDR block of the VPC fetched from the data source"
}
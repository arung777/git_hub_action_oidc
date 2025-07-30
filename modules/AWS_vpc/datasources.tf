data "aws_vpc" "myvpc" {
  id = aws_vpc.myvpc.id
  filter {
    name   = "tag:Name"
    values = [var.vpc_tag_name]
  }
}




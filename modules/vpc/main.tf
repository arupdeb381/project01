# VPC & Security Group
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.env}-my-vpc"
    Env  = var.env
  }
}

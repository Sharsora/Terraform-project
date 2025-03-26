# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.VPC_CIDR
  instance_tenancy        = "default"
  enable_dns_hostnames    = true
  enable_dns_support =  true

  tags      = {
    Name    = "${var.PROJECT_NAME}-vpc"
  }
}

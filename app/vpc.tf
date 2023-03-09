# --------------------------------------------------------------
# VPC
# --------------------------------------------------------------
resource "aws_vpc" "myvpc01" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc-01"
  }
}

# --------------------------------------------------------------
# Subnet
# --------------------------------------------------------------
resource "aws_subnet" "mysubnet01" {
  vpc_id = aws_vpc.myvpc01.id

  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "my-subnet-01"
  }
}
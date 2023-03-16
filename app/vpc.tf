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
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet-01"
  }
}

# --------------------------------------------------------------
# Internet Gateway
# --------------------------------------------------------------
resource "aws_internet_gateway" "myig" {
  vpc_id = aws_vpc.myvpc01.id

  tags = {
    Name = "myig"
  }
}

# --------------------------------------------------------------
# Route Table
# --------------------------------------------------------------
resource "aws_route_table" "inettable" {
  vpc_id = aws_vpc.myvpc01.id

  tags = {
    Name = "inettable"
  }
}

resource "aws_route" "inettable" {
  route_table_id         = aws_route_table.inettable.id
  gateway_id             = aws_internet_gateway.myig.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "mysubnet01_route" {
  subnet_id      = aws_subnet.mysubnet01.id
  route_table_id = aws_route_table.inettable.id
}

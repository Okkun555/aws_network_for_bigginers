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

resource "aws_subnet" "mysubnet02" {
  vpc_id = aws_vpc.myvpc01.id

  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "privatesubnet" {
  vpc_id = aws_vpc.myvpc01.id

  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "private-subnet"
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
# NAR Gateway 都度削除する
# --------------------------------------------------------------
resource "aws_eip" "mynatgweip" {
  vpc = true

  tags = {
    Name = "my-natgw-eip"
  }
}

resource "aws_nat_gateway" "mynatgw" {
  allocation_id = aws_eip.mynatgweip.id
  subnet_id     = aws_subnet.mysubnet01.id

  tags = {
    Name = "my-natgw"
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

resource "aws_route_table_association" "mysubnet02_route" {
  subnet_id      = aws_subnet.mysubnet02.id
  route_table_id = aws_route_table.inettable.id
}

# NAT Gatewayを経由してインターネットに疎通する為のルートテーブル
resource "aws_route_table" "nattable" {
  vpc_id = aws_vpc.myvpc01.id

  tags = {
    Name = "nattable"
  }
}

resource "aws_route" "nattable" {
  route_table_id         = aws_route_table.nattable.id
  nat_gateway_id         = aws_nat_gateway.mynatgw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "privatesubnet_route" {
  subnet_id      = aws_subnet.privatesubnet.id
  route_table_id = aws_route_table.nattable.id
}

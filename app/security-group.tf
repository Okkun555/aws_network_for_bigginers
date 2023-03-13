resource "aws_security_group" "webserverSG" {
  name   = "webserverSG"
  vpc_id = aws_vpc.myvpc01.id

  tags = {
    Name = "web-server-sg"
  }
}

# インバウンドルール
resource "aws_security_group_rule" "in_ssh" {
  security_group_id = aws_security_group.webserverSG.id
  type              = "ingress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
}

# アウトバウンドルール
resource "aws_security_group_rule" "out_all" {
  security_group_id = aws_security_group.webserverSG.id
  type              = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  from_port = 0
  to_port   = 0
  protocol  = "-1"
}
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
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_http" {
  security_group_id = aws_security_group.webserverSG.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_https" {
  security_group_id = aws_security_group.webserverSG.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
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

# defaultのセキュリティグループ
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.myvpc01.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
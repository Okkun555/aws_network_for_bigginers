# --------------------------------------------------------------
#  key pairの設定
# --------------------------------------------------------------
variable "key_name" {
  type        = string
  description = "keypair name"
  default     = "mykey"
}


# --------------------------------------------------------------
#  AMIの取得
# --------------------------------------------------------------
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# --------------------------------------------------------------
# EC2
# --------------------------------------------------------------
resource "aws_instance" "mywebserver" {
  ami                         = data.aws_ssm_parameter.amzn2_ami.value
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.webserverSG.id]
  subnet_id                   = aws_subnet.mysubnet01.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  tags = {
    Name = "my-web-server"
  }
}

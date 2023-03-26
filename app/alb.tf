resource "aws_lb" "my-alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.mysubnet01.id}", "${aws_subnet.mysubnet02.id}"]
  security_groups    = ["${aws_security_group.webserverSG.id}"]
}

resource "aws_lb_listener" "my-alb-listener" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-alb-gp.arn
  }
}

resource "aws_lb_target_group" "my-alb-gp" {
  name     = "my-alb-gp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc01.id
}

resource "aws_lb_target_group_attachment" "my-alb-gp_mywevserver01" {
  target_group_arn = aws_lb_target_group.my-alb-gp.arn
  target_id        = aws_instance.mywebserver01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "my-alb-gp_mywevserver02" {
  target_group_arn = aws_lb_target_group.my-alb-gp.arn
  target_id        = aws_instance.mywebserver02.id
  port             = 80
}
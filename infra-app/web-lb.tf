# Web ALB (Public)
resource "aws_lb" "web-alb" {
  name               = "${var.env}-web-alb"
  internal           = false  # Public facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.WebSG.id]
  subnets            = [
    aws_subnet.web_snet-01-1a.id,
    aws_subnet.web_snet-02-1b.id
  ]
}

# Web Target Group
resource "aws_lb_target_group" "web-tg" {
  name     = "${var.env}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}

# Attach Web EC2s
resource "aws_lb_target_group_attachment" "web-01" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.web-ec2-01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web-02" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.web-ec2-02.id
  port             = 80
}
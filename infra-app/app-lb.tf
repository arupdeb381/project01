# App ALB (Internal)
resource "aws_lb" "app-alb" {
  name               = "${var.env}-app-alb"
  internal           = true  # Internal only
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app-sg.id]
  subnets            = [
    aws_subnet.app_snet-01-1a.id,
    aws_subnet.app_snet-02-1b.id
  ]
}

# App Target Group
resource "aws_lb_target_group" "app-tg" {
  name     = "${var.env}-app-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}

# Attach App EC2s
resource "aws_lb_target_group_attachment" "app-01" {
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = aws_instance.app-ec2-01.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "app-02" {
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = aws_instance.app-ec2-02.id
  port             = 3000
}
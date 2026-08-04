resource "aws_lb_target_group" "web_app_target_group" {

  name = "${var.environment}-tg2-2"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.vpc.id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.environment}-tg"
  }
}
#Register Web Instanc4
resource "aws_lb_target_group_attachment" "web_app_attachment" {

  target_group_arn = aws_lb_target_group.web_app_target_group.arn

  target_id = aws_instance.web_app_ec2.id

  port = 80
}

# ALB

resource "aws_lb" "web_app_alb" {

  name = "${var.environment}-alb2-2"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_subnet_az1.id,
    aws_subnet.public_subnet_az2.id
  ]

  tags = {
    Name = "${var.environment}-alb"
  }
}

# Listener

resource "aws_lb_listener" "http_listener" {

  load_balancer_arn = aws_lb.web_app_alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.web_app_target_group.arn
  }
}
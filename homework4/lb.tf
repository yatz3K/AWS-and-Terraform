resource "aws_lb" "web-nginx" {
  name                       = "nginx-alb-${module.vpc.vpc_id}"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = module.vpc.public_subnets_id
  security_groups            = [aws_security_group.nginx_instances_access.id]

  tags = {
    "Name" = "nginx-alb-${module.vpc.vpc_id}"
  }
}

resource "aws_lb_listener" "web-nginx" {
  load_balancer_arn = aws_lb.web-nginx.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web-nginx.arn
    forward {
        target_group {
          arn = aws_lb_target_group.web-nginx.arn
        }
        stickiness {
          enabled = true
          duration = 60
        }
    }
  }
}

resource "aws_lb_target_group" "web-nginx" {
  name     = "nginx-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled = true
    path    = "/"
  }

  tags = {
    "Name" = "nginx-target-group-${module.vpc.vpc_id}"
  }
}

resource "aws_lb_target_group_attachment" "web_server" {
  count            = length(aws_instance.nginx)
  target_group_arn = aws_lb_target_group.web-nginx.id
  target_id        = aws_instance.nginx.*.id[count.index]
  port             = 80
}
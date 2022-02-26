resource "aws_lb" "whiskey_lb" {
  name = "whiskey-lb"
  internal = false
  load_balancer_type = "application"
  subnets = [aws_subnet.public-az-1a.id, aws_subnet.public-az-1c.id]
  security_groups = [aws_security_group.web-access-whiskey1.id, aws_security_group.web-access-whiskey2.id]

}

resource "aws_lb_target_group" "whiskey_lb" {
    name = "whiskey-lb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.whiskey_vpc.id
    health_check {
      protocol = "HTTP"
      path = "/"
    }
}

resource "aws_lb_target_group_attachment" "whiskey_lb-group-1" {
    target_group_arn = aws_lb_target_group.whiskey_lb.arn
    target_id = aws_instance.whiskey1.id
    port = 80
}

resource "aws_lb_target_group_attachment" "whiskey_lb-group-2" {
    target_group_arn = aws_lb_target_group.whiskey_lb.arn
    target_id = aws_instance.whiskey2.id
    port = 80
}
resource "aws_lb_listener" "whiskey_lb" {
    load_balancer_arn = aws_lb.whiskey_lb.arn
    port = 80
    protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.whiskey_lb.arn
  }
}
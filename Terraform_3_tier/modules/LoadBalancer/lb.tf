resource "aws_lb" "app-lb" {
  name_prefix = "app-lb"
  internal = false
  load_balancer_type = "application"
  subnets = var.public_subnet_ids
  security_groups = var.sg_id
}

resource "aws_lb_listener" "lb-listner" {
  load_balancer_arn = aws_lb.app-lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = var.tg_arn
  }
}
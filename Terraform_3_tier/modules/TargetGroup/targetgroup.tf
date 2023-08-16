resource "aws_lb_target_group" "tg" {
  name_prefix = "lb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

output "tg_arn" {
  value = aws_lb_target_group.tg.arn
}

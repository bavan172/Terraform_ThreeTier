resource "aws_autoscaling_group" "appasg" {
  name                      = "app-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 200
  desired_capacity          = 2
  launch_template {
    id      = var.template_id
    version = "$Latest"
  }
  vpc_zone_identifier       = var.subnets
  target_group_arns = [var.tg_arn]
}
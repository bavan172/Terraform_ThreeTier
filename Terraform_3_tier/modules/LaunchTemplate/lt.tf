resource "aws_launch_template" "apptemplate" {
  name = "app-template"

  image_id = var.img_id

  instance_type = "t2.micro"

  key_name = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups = var.sg_id
  }

}

output "launch-template-id" {
  value = aws_launch_template.apptemplate.id
}
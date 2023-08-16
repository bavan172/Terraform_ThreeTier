resource "aws_instance" "local_webserver" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  depends_on = [var.instance_depends_on]
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.sg_id
  key_name = var.key_name
  user_data = var.ec2_data
  # connection {
  #   timeout = "2m"
  #   timeout_wait = "3m"
    
  #   provisioner "remote-exec" {
  #     inline = [
  #       "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
  #     ]
  #   }
  # }
  tags = {
    Name = var.local_instance_name
  }
}

output "local_instance_id" {
    value = aws_instance.local_webserver.id
}
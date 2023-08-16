resource "aws_instance" "bastion" {
  depends_on = [var.depends_on_instance_id]
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.sg_id
  key_name = var.key_name
  tags = {
    Name = "bastion-for-asg"
  }
}

output "bastion_host_id" {
    value = aws_instance.bastion.id
}
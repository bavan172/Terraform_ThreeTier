resource "aws_security_group" "webserver_public" {
  vpc_id      = var.vpc_id
  name        = "webserver-allow-ssh-http"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.image_instance_allow_ssh_cidr
  }
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "webserver-allow-ssh-http"
  }
}

resource "aws_security_group" "bastion_host" {
  vpc_id      = var.vpc_id
  name        = "bastion-allow-ssh"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_allow_ssh_cidr
  }

  tags = {
    Name = "bastion-allow-ssh"
  }
}

resource "aws_security_group" "webserver_private" {
  vpc_id      = var.vpc_id
  name        = "webserver-pvt-allow-ssh-http"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.loadbalancer.id]
}
ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.loadbalancer.id]
}
  tags = {
    Name = "webserver-pvt-allow-ssh-http"
  }
}

resource "aws_security_group" "loadbalancer" {
  vpc_id      = var.vpc_id
  name        = "loadbalancer-allow-https-http"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "loadbalancer-allow-https-http"
  }
}

resource "aws_security_group" "rds" {
  vpc_id      = var.vpc_id
  name        = "rds-allow-webserver"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = var.rds_port
    to_port = var.rds_port
    protocol = "tcp"
    security_groups = [aws_security_group.webserver_private.id]
}
  tags = {
    Name = "rds-allow-ssh-http"
  }
}

output "webserver-public-sg-id" {
  value = aws_security_group.webserver_public.id
}
output "webserver-private-sg-id" {
  value = aws_security_group.webserver_private.id
}
output "loadbalancer-sg-id" {
  value = aws_security_group.loadbalancer.id
}
output "rds-sg-id" {
  value = aws_security_group.rds.id
}
output "bastion-sg-id" {
  value = aws_security_group.bastion_host.id
}
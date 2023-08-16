resource "aws_db_instance" "rds" {
  identifier = "appdb"
  depends_on = [aws_db_subnet_group.s_group]
  engine = var.engine
  allocated_storage    = var.allocated_storage
  max_allocated_storage = 0
  engine_version = var.engine_version
  instance_class = "db.t2.micro"
  db_name = "appdb"
  username = var.username
  password = var.password
  vpc_security_group_ids = var.sg_id
  db_subnet_group_name = "app-rds-group"
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "s_group" {
  name = "app-rds-group"
  subnet_ids = var.private_subnet_ids
}




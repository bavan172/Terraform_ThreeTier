variable "AWS_REGION" {
  default = "us-west-1"
}

variable "Vpc_Name"{
  default = "webapp-vpc"
}

variable "Vpc_CIDR"{
  default = "172.29.0.0/16"
}

variable "App_Public_Subnet_CIDR"{
  default = ["172.29.34.0/26" , "172.29.34.64/26" ] # Use maximum 2 CIDR
}

variable "App_Private_Subnet_CIDR"{
  default = ["172.29.35.0/26" , "172.29.35.64/26" ] # Use maximum 2 CIDR
}

variable "RDS_Private_Subnet_CIDR"{
  default = ["172.29.36.0/26" , "172.29.36.64/26" ] # Use maximum 2 CIDR
}

variable "app_subnet_name" {
  default = "app"
}

variable "rds_subnet_name" {
  default = "rdsdb"
}

variable "local_instance_name"{
  default="local-webserver"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-2 = "ami-0a59f0e26c55590e9"
    us-west-2 = "ami-0a7d051a1c4b54f65"
    us-west-1 = "ami-0427c7b524bf024ed"
    eu-west-1 = "ami-04c58523038d79132"
  }
}

variable "key_pair_name" {
  default = "webapp"
}

variable "local_ec2_data" {
  default =  <<EOF
#!/bin/bash
apt update -y
apt upgrade -y
apt install apache2 -y
apt install mysql-client -y
EOF
}

variable image_instance_allow_ssh_cidr {
  default = ["0.0.0.0/0"]
}

variable bastion_allow_ssh_cidr {
  default = ["0.0.0.0/0"]
}

variable rds_port {
  default = 3306
}

variable rds_engine{
  default = "mysql"
}

variable rds_engine_version {
  default = "8.0.25"
}

variable rds_allocated_storage {
  default = 10
}

variable rds_parameter_group_name {
  default = "default.mysql8.0"
}

variable rds_username {
  default = "admin"
}

variable rds_password {
  default = "password"
}
# ["172.29.35.0/26" , "172.29.35.64/26" ]
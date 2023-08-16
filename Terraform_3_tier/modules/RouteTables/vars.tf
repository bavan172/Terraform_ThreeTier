variable vpc_id {}
variable igw_id {}
variable public_subnet_id {}
variable private_subnet_id {}
variable "private_route_depends_on"{
  type = any
  default=[]
}
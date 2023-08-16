
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc"{
    source  = "../modules/VPC"
    vpc_name = var.Vpc_Name
    vpc_cidr = var.Vpc_CIDR
}

module "subnet"{
    source  = "../modules/Subnets"
    public_subnets_cidr = var.App_Public_Subnet_CIDR
    vpc_id = module.vpc.vpc-id
    public_availability_zones = data.aws_availability_zones.available.names
    private_subnets_cidr = var.App_Private_Subnet_CIDR
    private_availability_zones = data.aws_availability_zones.available.names
    subnet_name = var.app_subnet_name
}

module "db_subnet"{
    source  = "../modules/Subnets"
    public_subnets_cidr = []
    vpc_id = module.vpc.vpc-id
    public_availability_zones = data.aws_availability_zones.available.names
    private_subnets_cidr = var.RDS_Private_Subnet_CIDR
    private_availability_zones = data.aws_availability_zones.available.names
    subnet_name = var.rds_subnet_name
}


module "routeTable"{
    source  = "../modules/RouteTables"
    vpc_id = module.vpc.vpc-id
    igw_id = module.vpc.igw-id
    public_subnet_id = module.subnet.public-subnet-id
    private_subnet_id = concat(module.subnet.private-subnet-id,module.db_subnet.private-subnet-id)
    private_route_depends_on = module.subnet.private-subnet-id
}

module "security_groups"{
    source  = "../modules/SecurityGroups"
    vpc_id = module.vpc.vpc-id
    image_instance_allow_ssh_cidr = var.image_instance_allow_ssh_cidr
    bastion_allow_ssh_cidr = var.bastion_allow_ssh_cidr
    rds_port = var.rds_port
}

module "loacl_instance"{
    source  = "../modules/ImageInstance"
    instance_depends_on = module.subnet.public-subnet-id[0]
    local_instance_name = var.local_instance_name
    subnet_id = module.subnet.public-subnet-id[0]
    ami_id = var.AMIS[var.AWS_REGION]
    key_name = var.key_pair_name
    sg_id = [module.security_groups.webserver-public-sg-id]
    ec2_data = var.local_ec2_data
}

resource "aws_ami_from_instance" "image" {
  depends_on = [module.bastion_host.bastion_host_id]
  name               = "webapp-ami"
  source_instance_id = module.loacl_instance.local_instance_id
}

module "launch_template"{
    source  = "../modules/LaunchTemplate"
    img_id = aws_ami_from_instance.image.id
    key_name = var.key_pair_name
    sg_id = [module.security_groups.webserver-private-sg-id]
}

module "auto_scaling_group"{
    source  = "../modules/AutoScalingGroup"
    template_id = module.launch_template.launch-template-id
    subnets = module.subnet.private-subnet-id
    tg_arn = module.target_group.tg_arn
}

module "bastion_host"{
    source  = "../modules/BastionHost"
    depends_on_instance_id = module.loacl_instance.local_instance_id
    subnet_id = module.subnet.public-subnet-id[0]
    ami_id = var.AMIS[var.AWS_REGION]
    key_name = var.key_pair_name
    sg_id = [module.security_groups.bastion-sg-id]
}

module "target_group"{
    source = "../modules/TargetGroup"
    vpc_id = module.vpc.vpc-id
}

module "load_balancer"{
    source = "../modules/LoadBalancer"
    public_subnet_ids = module.subnet.public-subnet-id
    sg_id = [module.security_groups.loadbalancer-sg-id]
    tg_arn = module.target_group.tg_arn
}

module "rds" {
    source = "../modules/RDS"
    engine = var.rds_engine
    engine_version = var.rds_engine_version
    sg_id = [module.security_groups.rds-sg-id]
    allocated_storage = var.rds_allocated_storage
    username = var.rds_username
    password = var.rds_password
    parameter_group_name = var.rds_parameter_group_name
    private_subnet_ids = module.db_subnet.private-subnet-id
}



module "vpc2"{
    source  = "../modules/VPC"
    providers = {
      aws = aws.otherregion
     }
    vpc_name = "other-vpc"
    vpc_cidr = "172.28.0.0/16"
}
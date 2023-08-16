


resource "aws_subnet" "public-subnet" {
    count="${length(var.public_subnets_cidr)}"
    vpc_id = var.vpc_id
    cidr_block = "${element(var.public_subnets_cidr, count.index)}"
    map_public_ip_on_launch = "true"
    availability_zone = "${element(var.public_availability_zones, count.index)}"
    tags = {
        Name = "${var.subnet_name}-${element(var.public_availability_zones, count.index)}- public-subnet"
    }
}

resource "aws_subnet" "private-subnet" {
    count="${length(var.private_subnets_cidr)}"
    vpc_id = var.vpc_id
    cidr_block = "${element(var.private_subnets_cidr, count.index)}"
    map_public_ip_on_launch = "false"
    availability_zone = "${element(var.private_availability_zones, count.index)}"
    tags = {
        Name = "${var.subnet_name}-${element(var.private_availability_zones, count.index)}- private-subnet"
    }
}

output "public-subnet-id" {
  value = aws_subnet.public-subnet[*].id
}
output "private-subnet-id" {
  value = aws_subnet.private-subnet[*].id
}
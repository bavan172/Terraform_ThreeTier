resource "aws_route_table" "public_route" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.igw_id
    }
    tags = {
        Name = "public-route"
    }
}

resource "aws_route_table" "private_route" {
    depends_on = [
      var.private_route_depends_on
    ]
    vpc_id = var.vpc_id
    tags = {
        Name = "private-route"
    }
}

resource "aws_route_table_association" "public" {
    count="${length(var.public_subnet_id)}"
    subnet_id = "${element(var.public_subnet_id, count.index)}"
    route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "private" {
    count="${length(var.private_subnet_id)}"
    subnet_id = "${element(var.private_subnet_id, count.index)}"
    route_table_id = aws_route_table.private_route.id
}

output "public-route-id" {
  value = aws_route_table.public_route.id
}
output "private-route-id" {
  value = aws_route_table.private_route.id
}
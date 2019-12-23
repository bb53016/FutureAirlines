# VPC
resource "aws_vpc" "testvpc" {
  cidr_block       = "${var.vpc_cidr}"
  tags = {
    Name = "${var.stack_name}-VPC"
    Owner = "${var.Owner}"
    team  = "${var.team}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "test_igw" {
  vpc_id = "${aws_vpc.testvpc.id}"
  tags = {
    Name = "main"
  }
}

# Subnets : public
resource "aws_subnet" "public" {
  count = "${length(var.public_cidrs)}"

  vpc_id = "${aws_vpc.testvpc.id}"
  cidr_block = "${element(var.public_cidrs, count.index)}"
  availability_zone = "${element(var.azs,count.index)}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.testvpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_igw.id}"
  }
  tags = {
    Name = "publicRouteTable"
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "public_ass" {
  count = "${length(var.public_cidrs)}"
  subnet_id      = "${element(aws_subnet.public.*.id,count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}


resource "aws_subnet" "private" {
  count             = "${length(var.private_cidrs)}"

  vpc_id            = "${aws_vpc.testvpc.id}"
  cidr_block        = "${element(var.private_cidrs, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "private-subnet-${count.index}"
  }
 }

 resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.testvpc.id}"
  
  tags = {
    Name = "privateRouteTable"
  }
}

# Route table association with private subnets
resource "aws_route_table_association" "private_ass" {
  count             = "${length(var.private_cidrs)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_rt.id}"
}

# create security group to allow traffic on port 80
resource "aws_security_group" "webservers" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = "${aws_vpc.testvpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    //cidr_blocks = ["${var.homeIPAddress}"]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.stack_name}-SG"
	  Owner = "${var.Owner}"
  }
}

resource "aws_security_group_rule" "all_to_core" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = -1
    security_group_id = "${aws_security_group.webservers.id}"
    self = true
}


resource "aws_network_acl" "nacl" {
  vpc_id = "${aws_vpc.testvpc.id}"
  subnet_ids = ["${aws_subnet.public.id}", "${aws_subnet.private.id}"]

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "Network ACL"
  }
}

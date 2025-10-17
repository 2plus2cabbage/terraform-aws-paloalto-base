# Creates a route table to direct traffic from the subnet to the internet
resource "aws_route_table" "public_route_table" {
  vpc_id               = aws_vpc.main_vpc.id                                     # VPC ID for the route table
  route {
    cidr_block         = "0.0.0.0/0"                                             # Route all traffic
    gateway_id         = aws_internet_gateway.main_igw.id                        # Direct to internet gateway
  }
  tags = {
    Name               = "rt-${var.environment_name}-${var.location}-default-001"       # Name of the route table
  }
}

resource "aws_route_table" "trust_route_table" {
  vpc_id               = aws_vpc.main_vpc.id                                     # VPC ID for the route table

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.trust.id
  }

  tags = {
   Name               = "rt-${var.environment_name}-${var.location}-trust-001"       # Name of the route table
  }
}


# Associates the route table with the untrust subnet for internet access
resource "aws_route_table_association" "management" {
  subnet_id      = aws_subnet.mgmt_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "untrust" {
  subnet_id      = aws_subnet.untrust_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "trust" {
  subnet_id      = aws_subnet.trust_subnet.id
  route_table_id = aws_route_table.trust_route_table.id
}
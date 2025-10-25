                                                                                          # Route Tables
                                                                                          # Creates a public route table to direct traffic from subnets to the internet
resource "aws_route_table" "public_route_table" {
  vpc_id                 = aws_vpc.main_vpc.id                                            # VPC ID for the route table
  route {
    cidr_block           = "0.0.0.0/0"                                                    # Route all traffic to any destination
    gateway_id           = aws_internet_gateway.main_igw.id                               # Direct traffic to the internet gateway
  }
  tags                   = {
    Name                 = "rt-${var.environment_name}-${var.location}-default-001"       # Name of the public route table
  }
}

                                                                                          # Creates a trust route table to direct traffic through the firewall
resource "aws_route_table" "trust_route_table" {
  vpc_id                 = aws_vpc.main_vpc.id                                            # VPC ID for the route table
  route {
    cidr_block           = "0.0.0.0/0"                                                    # Route all traffic to any destination
    network_interface_id = aws_network_interface.trust.id                                 # Direct traffic to the firewall trust NIC
  }
  tags                   = {
    Name                 = "rt-${var.environment_name}-${var.location}-trust-001"         # Name of the trust route table
  }
}

                                                                                          # Route Table Associations
                                                                                          # Associates the public route table with the management subnet for internet access
resource "aws_route_table_association" "management" {
  subnet_id              = aws_subnet.mgmt_subnet.id                                      # Management subnet to associate
  route_table_id         = aws_route_table.public_route_table.id                          # Public route table for internet access
}

                                                                                          # Associates the public route table with the untrust subnet for internet access
resource "aws_route_table_association" "untrust" {
  subnet_id              = aws_subnet.untrust_subnet.id                                   # Untrust subnet to associate
  route_table_id         = aws_route_table.public_route_table.id                          # Public route table for internet access
}

                                                                                          # Associates the trust route table with the trust subnet for internal traffic
resource "aws_route_table_association" "trust" {
  subnet_id              = aws_subnet.trust_subnet.id                                     # Trust subnet to associate
  route_table_id         = aws_route_table.trust_route_table.id                           # Trust route table for firewall routing
}
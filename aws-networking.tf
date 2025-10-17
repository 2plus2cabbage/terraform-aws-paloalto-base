                                                                                         # Creates a virtual private cloud (VPC) to host subnets and resources
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.3.0.0/16"                                                   # CIDR block for the VPC
  enable_dns_support   = true                                                            # Enable DNS support
  enable_dns_hostnames = true                                                            # Enable DNS hostnames
  tags                 = {
    Name               = "${local.vpc_name}001"                                          # Name of the VPC
  }
}

                                                                                         # Creates management subnet for firewall management interfaces
resource "aws_subnet" "mgmt_subnet" {
  vpc_id               = aws_vpc.main_vpc.id                                             # VPC ID for the subnet
  cidr_block           = "10.3.0.0/24"                                                   # CIDR block for the subnet
  availability_zone    = "${var.region}a"                                                # Availability zone (e.g., us-east-1a)
  tags                 = {
    Name               = "${local.subnet_name_prefix}mgmt-001"                           # Name of the subnet
  }
}

                                                                                         # Creates untrust subnet for firewall external interfaces
resource "aws_subnet" "untrust_subnet" {
  vpc_id               = aws_vpc.main_vpc.id                                             # VPC ID for the subnet
  cidr_block           = "10.3.1.0/24"                                                   # CIDR block for the subnet
  availability_zone    = "${var.region}a"                                                # Availability zone (e.g., us-east-1a)
  tags                 = {
    Name               = "${local.subnet_name_prefix}untrust-001"                        # Name of the subnet
  }
}

                                                                                         # Creates trust subnet for internal traffic
resource "aws_subnet" "trust_subnet" {
  vpc_id               = aws_vpc.main_vpc.id                                             # VPC ID for the subnet
  cidr_block           = "10.3.2.0/24"                                                   # CIDR block for the subnet
  availability_zone    = "${var.region}a"                                                # Availability zone (e.g., us-east-1a)
  tags                 = {
    Name               = "${local.subnet_name_prefix}trust-001"                          # Name of the subnet
  }
}

                                                                                         # Creates an internet gateway for internet access
resource "aws_internet_gateway" "main_igw" {
  vpc_id               = aws_vpc.main_vpc.id                                             # VPC ID for the internet gateway
  tags                 = {
    Name               = "${local.internet_gateway_name_prefix}001"                      # Name of the internet gateway
  }
}
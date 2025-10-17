# Defines local variables for naming conventions in AWS
locals {
  vpc_name                      = "vpc-${var.environment_name}-${var.location}-"           # Prefix for VPC name
  subnet_name_prefix            = "snet-${var.environment_name}-${var.location}-"          # Prefix for subnet name
  windows_name_prefix           = "vm-${var.environment_name}-${var.location}-windows-"    # Prefix for Windows VM name
  security_group_name_prefix    = "secgroup-${var.environment_name}-${var.location}-"      # Prefix for security group name
  internet_gateway_name_prefix  = "igw-${var.environment_name}-${var.location}-"           # Prefix for internet gateway name
  network_interface_prefix      = "nic-${var.environment_name}-${var.location}-"           # Prefix for network interface name
  firewall_name_prefix          = "fw-${var.environment_name}-${var.location}-"            # Prefix for firewall instance name
}
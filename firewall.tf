                                                                                            # Management NIC for Firewall
resource "aws_network_interface" "management" {
  subnet_id                 = aws_subnet.mgmt_subnet.id                                     # Management subnet
  private_ips               = ["10.3.0.10"]                                                 # Static IP for Firewall A mgmt
  security_groups           = [aws_security_group.mgmt_sg.id]                               # Management security group
  tags                      = {
    Name                    = "${local.network_interface_prefix}fw-mgmt-001"                # Name of the NIC
  }
}

                                                                                            # Untrust NIC for Firewall
resource "aws_network_interface" "untrust" {
  subnet_id                 = aws_subnet.untrust_subnet.id                                  # Untrust subnet
  private_ips               = ["10.3.1.10"]                                                 # Static IP for Firewall A untrust
  security_groups           = [aws_security_group.untrust_sg.id]                            # Untrust security group
  source_dest_check         = false                                                         # Disable source/dest check for routing
  tags                      = {
    Name                    = "${local.network_interface_prefix}fw-untrust-001"             # Name of the NIC
  }
}

                                                                                            # Trust NIC for Firewall
resource "aws_network_interface" "trust" {
  subnet_id                 = aws_subnet.trust_subnet.id                                    # Trust subnet
  private_ips               = ["10.3.2.10"]                                                 # Static IP for Firewall A trust
  security_groups           = [aws_security_group.trust_sg.id]                              # Trust security group
  source_dest_check         = false                                                         # Disable source/dest check for routing
  tags                      = {
    Name                    = "${local.network_interface_prefix}fw-trust-001"               # Name of the NIC
  }
}

                                                                                            # Elastic IP for Firewall management interface
resource "aws_eip" "management" {
  domain                    = "vpc"                                                         # VPC domain for EIP
  network_interface         = aws_network_interface.management.id                           # Management NIC for Firewall
  associate_with_private_ip = "10.3.0.10"                                                   # Specific private IP for EIP
  depends_on                = [aws_internet_gateway.main_igw]                               # Ensure internet gateway exists
  tags                      = {
    Name                    = "${local.network_interface_prefix}fw-mgmt-eip-001"            # Name of the EIP
  }
}

                                                                                            # Elastic IP for untrust interface
resource "aws_eip" "untrust" {
  domain                    = "vpc"                                                         # VPC domain for EIP
  network_interface         = aws_network_interface.untrust.id                              # Untrust NIC for Firewall
  associate_with_private_ip = "10.3.1.10"                                                   # Specific private IP for EIP
  depends_on                = [aws_internet_gateway.main_igw]                               # Ensure internet gateway exists
  tags                      = {
    Name                    = "${local.network_interface_prefix}fw-untrust-eip-001"         # Name of the EIP
  }
}

                                                                                            # Palo Alto Firewall Instance
                                                                                            # Firewall EC2 instance
resource "aws_instance" "palo_alto" {
  ami                       = var.firewall_ami                                              # VM-Series AMI
  instance_type             = var.firewall_instance_type                                    # Instance type for firewall
  key_name                  = var.key_name                                                  # Key pair for SSH access
  primary_network_interface {
    network_interface_id    = aws_network_interface.management.id                           # Management NIC
    }
                                                                                            # User data for DHCP configuration
  user_data                 = <<-EOF
                            type=dhcp-client
                            EOF
  tags                      = {
    Name                    = "${local.firewall_name_prefix}001"                            # Name of Firewall
  }
}

resource "aws_network_interface_attachment" "fw_nic_untrust" {
    instance_id = aws_instance.palo_alto.id
    network_interface_id    = aws_network_interface.untrust.id                              # Untrust NIC
    device_index = 1
}

resource "aws_network_interface_attachment" "fw_nic_trust" {
    instance_id = aws_instance.palo_alto.id
    network_interface_id    = aws_network_interface.trust.id                              # Trust NIC
    device_index = 2
}
                                                                                            # Output for firewall management IP
output "management_public_ip" {
  description               = "Management interface public IP"                              # Description of the output
  value                     = aws_eip.management.public_ip                                  # Public IP for firewall mgmt
}

                                                                                            # Output for untrust public IP
output "untrust_public_ip" {
  description               = "Untrust interface public IP"                                 # Description of the output
  value                     = aws_eip.untrust.public_ip                                     # Public IP for the untrust interface
}
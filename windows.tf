                                                                                                          # Network Interface for Windows VM
resource "aws_network_interface" "windows_nic" {
  subnet_id                     = aws_subnet.trust_subnet.id                                              # Trust subnet
  private_ips                   = ["10.3.2.20"]                                                           # Static IP for Windows VM
  security_groups               = [aws_security_group.trust_sg.id]                                        # Trust security group
  tags                          = {
    Name                        = "${local.network_interface_prefix}windows-001"                          # Name of the NIC
  }
}

                                                                                                          # Creates a Windows Server 2022 VM instance in AWS
resource "aws_instance" "windows_instance" {
  ami                           = "ami-008a7af5c4c774b52"                                                 # Windows Server 2022 in us-east-1
  instance_type                 = "t3.medium"                                                             # Instance type (compute resources)
  key_name                      = var.key_name                                                            # Key pair for password retrieval
  network_interface {
    network_interface_id        = aws_network_interface.windows_nic.id                                    # Windows NIC
    device_index                = 0                                                                       # Primary interface index
  }
  user_data                     = "<powershell>netsh advfirewall set allprofiles state off</powershell>"  # Disables firewall on boot
  tags                          = {
    Name                        = "${local.windows_name_prefix}001"                                       # Name of the Windows VM
  }
}

                                                                                                          # Outputs the private IP of the Windows VM for internal networking
output "aws_vm_private_ip" {
  value                         = aws_network_interface.windows_nic.private_ip                            # Static private IP of the Windows VM
  description                   = "Private IP of the AWS Windows VM"                                      # Description of the output
}
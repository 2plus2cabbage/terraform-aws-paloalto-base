# Creates a Windows Server 2022 VM instance in AWS
resource "aws_instance" "windows_instance" {
  ami                           = "ami-008a7af5c4c774b52"                                                   # Windows Server 2022 in us-east-1
  instance_type                 = "t3.medium"                                                               # Instance type (compute resources)
  subnet_id                     = aws_subnet.trust_subnet.id                                                # Subnet for the VM
  vpc_security_group_ids        = [aws_security_group.trust_sg.id]                                          # Security group for the VM
  associate_public_ip_address   = false                                                                     # No public IP assignment
  key_name                      = var.key_name                                                              # Key pair for password retrieval
  user_data                     = "<powershell>netsh advfirewall set allprofiles state off</powershell>"    # Disables firewall on boot
  tags                          = {
    Name                        = "${local.windows_name_prefix}001"                                         # Name of the Windows VM
  }
}
                                                                                                            # Outputs the private IP of the Windows VM for internal networking
output "aws_vm_private_ip" {
  value                         = aws_instance.windows_instance.private_ip                                  # Private IP address of the VM
  description                   = "Private IP of the AWS Windows VM"                                        # Description of the output
}
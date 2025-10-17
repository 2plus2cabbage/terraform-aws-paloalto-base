# AWS access key for authentication
variable "access_key" {
  type        = string
  description = "AWS access key, found in AWS console under IAM"
}

# AWS secret key for authentication
variable "secret_key" {
  type        = string
  description = "AWS secret key, found in AWS console under IAM"
}

# AWS region for deployment
variable "region" {
  type        = string
  description = "AWS region for deployment"
}

# Environment name for resource naming
variable "environment_name" {
  type        = string
  description = "Name for your environment, used in resource naming"
}

# Location identifier for resource naming
variable "location" {
  type        = string
  description = "Location identifier, used in resource naming"
}

# Public IP for management and RDP access
variable "my_public_ip" {
  type        = string
  description = "Your public IP for RDP and firewall management access"
}

# Key pair name for EC2 instance access
variable "key_name" {
  type        = string
  description = "Name of the key pair for password retrieval"
}

# AMI ID for Palo Alto VM-Series firewall
variable "firewall_ami" {
  type        = string
  description = "AMI ID for Palo Alto VM-Series firewall"
  default     = "ami-075a7ab0b756f38f9"
}

# Instance type for firewalls
variable "firewall_instance_type" {
  type        = string
  description = "Instance type for Palo Alto VM-Series firewalls"
  default     = "m5.4xlarge"
}
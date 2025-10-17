# Configures the AWS provider with authentication details for Terraform to manage AWS resources
provider "aws" {
  access_key                 = var.access_key        # AWS access key for authentication
  secret_key                 = var.secret_key        # AWS secret key for authentication
  region                     = var.region            # AWS region for deployment
}
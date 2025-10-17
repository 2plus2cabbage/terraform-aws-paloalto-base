<img align="right" width="150" src="https://github.com/2plus2cabbage/2plus2cabbage/blob/main/images/2plus2cabbage.png">

<img src="https://github.com/2plus2cabbage/2plus2cabbage/blob/main/images/aws-base.png" alt="aws-base" width="300" align="left">
<br clear="left">

# AWS Windows Instance Terraform Deployment

Deploys a Windows Server 2022 VM in Amazon Web Services (AWS) with RDP and internet access.

## Files
The project is split into multiple files to illustrate modularity and keep separate constructs distinct, making it easier to manage and understand.
- `main.tf`: Terraform provider block (`hashicorp/aws`).
- `awsprovider.tf`: AWS provider config with `access_key`, `secret_key`, etc.
- `variables.tf`: Variables for region, etc.
- `terraform.tfvars.template`: Template for sensitive/custom values; rename to `terraform.tfvars` and add your credentials.
- `locals.tf`: Local variables for naming conventions.
- `aws-networking.tf`: VPC, subnet, internet gateway.
- `securitygroup.tf`: Security group for RDP (TCP 3389) and outbound traffic.
- `routing-static.tf`: Route table for internet access.
- `windows.tf`: Windows VM, outputs public/private IPs.

## How It Works
- **Networking**: VPC and subnet provide connectivity. Route table enables inbound/outbound traffic.
- **Security**: Allows RDP from your IP and all outbound traffic.
- **Instance**: Windows Server 2022 VM with public IP, firewall disabled via user data.

## Prerequisites
- An AWS account with a key pair for EC2 instances.
- AWS credentials, noting `access_key`, `secret_key`, and `region`.
- Terraform installed on your machine.
- Examples are demonstrated using Visual Studio Code (VSCode).

## Deployment Steps
1. Update `terraform.tfvars` with AWS credentials, key pair name in `key_name`, and your public IP in `my_public_ip`.
2. Run `terraform init`, then (optionally) `terraform plan` to preview changes, then `terraform apply` (type `yes`).
3. Get the public IP from the `aws_vm_public_ip` output on the screen, or run `terraform output aws_vm_public_ip`, or check in the AWS Console under **EC2 > Instances**.
4. Retrieve the initial password in the AWS Console under **EC2 > Instances > [select instance] > Actions > Security > Get Windows Password**, using the key pair specified in `key_name`.
5. Use Remote Desktop to log in with the `Administrator` user and the retrieved initial password.
6. To remove all resources, run `terraform destroy` (type `yes`).

## Potential costs and licensing
- The resources deployed using this Terraform configuration should generally incur minimal to no costs, provided they are terminated promptly after creation.
- It is important to fully understand your cloud provider's billing structure, trial periods, and any potential costs associated with the deployment of resources in public cloud environments.
- You are also responsible for any applicable software licensing or other charges that may arise from the deployment and usage of these resources.
<img align="right" width="150" src="https://github.com/2plus2cabbage/2plus2cabbage/blob/main/images/2plus2cabbage.png">

<img src="https://github.com/2plus2cabbage/2plus2cabbage/blob/main/images/aws-paloalto-base.png" alt="aws-paloalto-base" width="300" align="left">
<br clear="left">

# AWS Palo Alto Firewall and Windows Instance Terraform Deployment

Deploys a Palo Alto VM-Series firewall and a Windows Server 2022 VM in Amazon Web Services (AWS) with management access for the firewall and RDP/internet access for the Windows VM.

## Files
The project is split into multiple files to illustrate modularity and keep separate constructs distinct, making it easier to manage and understand.
- `main.tf`: Terraform provider block (`hashicorp/aws`) and version requirements.
- `awsprovider.tf`: AWS provider config with `access_key`, `secret_key`, and region.
- `variables.tf`: Variables for region, firewall AMI, instance types, etc.
- `terraform.tfvars.template`: Template for sensitive/custom values; rename to `terraform.tfvars` and add your credentials.
- `locals.tf`: Local variables for naming conventions.
- `aws-networking.tf`: VPC, management, untrust, and trust subnets, and internet gateway.
- `securitygroup.tf`: Security groups for firewall management (HTTPS/SSH), untrust (all traffic), and trust (all traffic).
- `routing-static.tf`: Route tables for internet access (management/untrust) and internal routing via firewall trust NIC.
- `firewall.tf`: Palo Alto firewall with management, untrust, and trust NICs, Elastic IPs, and public IP outputs.
- `windows.tf`: Windows VM, outputs private IP.

## How It Works
- **Networking**: VPC with management, untrust, and trust subnets provides connectivity. The management and untrust subnets use a public route table for internet access, while the trust subnet routes traffic through the firewall’s trust NIC.
- **Security**: Firewall management security group allows HTTPS (443) and SSH (22) from your specified IP. Untrust and trust security groups allow all traffic. Windows VM uses the trust security group for internal access.
- **Firewall**: Palo Alto VM-Series instance with three NICs: management (10.3.0.10) for HTTPS/SSH access, untrust (10.3.1.10) for external traffic, and trust (10.3.2.10) for internal traffic. Elastic IPs are assigned to management and untrust NICs for public access.
- **Instance**: Windows Server 2022 VM in the trust subnet with no public IP, firewall disabled via user data for internal access.

## Prerequisites
- An AWS account with a key pair for EC2 instances.
- AWS credentials, noting `access_key`, `secret_key`, and `region`.
- A valid Palo Alto VM-Series AMI ID for your region (specified in `firewall_ami`).
- Terraform installed on your machine.
- Examples are demonstrated using Visual Studio Code (VSCode).

## Deployment Steps
1. Update `terraform.tfvars` with AWS credentials, key pair name in `key_name`, your public IP in `my_public_ip`, and a valid Palo Alto AMI ID in `firewall_ami` if different from the default.
2. Run `terraform init`, then (optionally) `terraform plan` to preview changes, then `terraform apply` (type `yes`).
3. Get the firewall management public IP from the `management_public_ip` output on the screen, or run `terraform output management_public_ip`, or check in the AWS Console under **EC2 > Instances**.
4. Use SSH to connect to the firewall management interface using the public IP and your key pair. Change the admin password by entering `configure`, then `set mgt-config users admin password`, and `commit`.
5. Use HTTPS to connect to the firewall management interface at `https://<management_public_ip>` using a web browser.
6. Update MY-PUBLIC-IP in `firewall-config.xml`: find and replace `5.5.5.5/32` with your actual public IP (same as `my_public_ip` in `terraform.tfvars`), then save the file.
7. Import the XML configuration via the GUI at `https://<management_public_ip>`: log in with username `fwadmin` and the password from `terraform.tfvars` (`firewall_admin_password`), go to Device > Setup > Operations > Import Named Configuration Snapshot, upload your XML file, then go to Device > Setup > Operations > Load Named Configuration Snapshot and select the imported file to load the configuration, and commit (note that after the commit, the admin password will be reset to `2Plus2cabbage!`).
8. Retrieve the Windows VM initial password in the AWS Console under **EC2 > Instances > [select instance] > Actions > Security > Get Windows Password**, using the key pair specified in `key_name`.
9. Use Remote Desktop to connect to the firewall’s untrust public IP at `<untrust_public_ip>`, obtained from the `untrust_public_ip` output or by running `terraform output untrust_public_ip`, to access the Windows VM with the `Administrator` user and the retrieved initial password, after configuring firewall rules.
10. To remove all resources, run `terraform destroy` (type `yes`).

## Potential costs and licensing
- The resources deployed using this Terraform configuration should generally incur minimal to no costs, provided they are terminated promptly after creation.
- The Palo Alto VM-Series firewall requires a valid license from Palo Alto Networks, which may incur additional costs. Ensure you have the appropriate licensing for the VM-Series AMI used in `firewall_ami`.
- It is important to fully understand your cloud provider's billing structure, trial periods, and any potential costs associated with the deployment of resources in public cloud environments.
- You are also responsible for any applicable software licensing or other charges that may arise from the deployment and usage of these resources.
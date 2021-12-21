# Terraform-Project

## About this project
This terraform project will create VPC, Load balancer, Autoscaling, and Route53 modules on user's AWS account. To use this project, user will need to download terraform and this project onto their local machine. 


## How to download Terraform 
#### For Windows:
1. Download the terraform ZIP file from Terraform site: https://www.terraform.io/downloads.html
2. Extract the .exe from the ZIP file to a folder (e.g., C:\Apps\Terraform) and copy this path location.
3. Add the folder location to your PATH variable, eg: `Control Panel` -> `System` -> `System settings` -> `Environment Variables`
4. In `System Variables`, select `Path` > `edit` > `new` > Enter the location of the Terraform.exe, (e.g., C:\Apps\Terraform) and then click `OK`
5. Verify that the installation worked by opening a new terminal session and listing Terraform's available subcommands such as `terraform -version`

#### For MacOS or Linux
1. Download the terraform ZIP file from Terraform site: https://www.terraform.io/downloads.html and extract the terraform binary file.
2. `echo $PATH`  =  Print a colon-separated list of locations in your PATH
3. `mv ~/Downloads/terraform /usr/local/bin/`  =  Move the Terraform binary to one of the listed locations. This command assumes that the binary is currently in your downloads folder and that your PATH includes /usr/local/bin, but you can customize it if your locations are different.
4. `terraform -version`  =  Verify that the installation worked by opening a new terminal session and listing Terraform's available subcommands


## VPC Module
#### Variables this module recieves:
1. vpc_cidr = "10.0.0.0/16"
2. Public Subnets:
    * public1_cidr = "10.0.0.0/24"
    * public2_cidr = "10.0.1.0/24"
    * public3_cidr = "10.0.2.0/24"
    * public1_az   = "us-east-1a"
    * public2_az   = "us-east-1b"
    * public3_az   = "us-east-1c"
3. Private Subnets:
    * private1_cidr = "10.0.3.0/24"
    * private2_cidr = "10.0.4.0/24"
    * private3_cidr = "10.0.5.0/24"
    * private1_az   = "us-east-1a"
    * private2_az   = "us-east-1b"
    * private3_az   = "us-east-1c"

#### Components created by this module
1. 3 private subnets
2. 3 public subnets
3. 1 internet gw
4. 1 nat gw
5. 2 Route Tables (1 public route table, 1 private route table)
6. 1 VPC


## Load balancer Module
#### Variables this module recieves:
1. vpc_id
2. public_subnets_id

#### Components created by this module
1. Load balancer 
2. Load balancer listner
3. Load balancer target group


## Autoscaling Module
#### Variables this module recieves:
1. vpc_id
2. private_subnets_id
3. tg-arn

#### Components created by this module
1. Key Pair 
2. Security Group
3. Launch Configuration 
4. Autoscaling Group


## Route53 Module
#### Variables this module recieves:
1. eip

#### Components created by this module
1. Route53 Zone 
2. Route53 Record


## Commands to launch the project
Assuming that project is downloaded and the user is in the project directory:
1. `terraform init` 
2. `terraform apply --var-file=config/aws.tfvars`
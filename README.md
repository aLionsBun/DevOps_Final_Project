# DevOps final project

This project was developed for DevOps university course.

## Technologies used
- AWS
- Terraform
- Docker
- Jenkins

## Project description
[Terraform](https://www.terraform.io/) is used to create the following infrasctucture in AWS:
- AWS Elastic Compute Cloud (EC2) that has attached:
    * Custom Security Group
    * SSH key pair
    * User data script
- AWS Simple Storage Service (S3)

After boot AWS EC2 executes script ec2_setup.sh attached as user data. This script:
- Installs [Docker](https://www.docker.com/)
- Copies Jenkins and Docker setup scripts to EC2
- Builds and starts Docker container with [Jenkins](https://www.jenkins.io/) configured using [CASC](https://plugins.jenkins.io/configuration-as-code/) and [Jb DSL](https://plugins.jenkins.io/job-dsl/) plugins

Jenkins seedjob contains sample pipelineJob that is configured to load [demo script](https://github.com/aLionsBun/Jenkins_Pipeline_Sample) and build pipeline configured in Jenkinfile.

## Project prerequisites
- Have Terraform installed on machine
- Have AWS IAM user configured with full access to EC2 and S3 resources
- Create `terraform.tfvars` in terraform folder to assign values to variables declared in `variables.tf`
- Create SSH key pair and provide valid path to SSH public key in `main.tf`

## Starting project
Navigate to folder with `main.tf` file and execute following commands:
```
// Initializing Terraform
terraform init

// Creating and saving Terraform plan with actions to be taken
terraform plan -out="./tfplan"

// Applying Terraform changes written in tfplan
terraform apply "./tfplan"
```
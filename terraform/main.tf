# Declaring AWS provider (one who calls to AWS API)
provider "aws" {
  region = "us-east-1"
  access_key = var.aws_api_key
  secret_key = var.aws_api_secret
}

# Creating AWS Security Group for EC2
resource "aws_security_group" "ec2_group" {
    name = "devops_security_group"
    description = "Security group that allows access for SSH and HTTP(S)"
    tags = {
        Name = "DevOps"
    }

    # Inbound rule to allow SSH
    ingress {
        description = "SSH inbound access"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Inbound rule to allow HTTP
    ingress {
        description = "HTTP inbound access"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Inbound rule to allow HTTPS
    ingress {
        description = "HTTPS inbound access"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Inbound rule to allow port 50000
    ingress {
        description = "Port 50000 inbound access"
        from_port = 50000
        to_port = 50000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Outbound rule to allow all traffic
    egress {
        description = "Outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Setting up SSH connection using existing key pair
resource "aws_key_pair" "ssh_key" {
  key_name   = "devops_key"
  public_key = file("${path.module}/../ssh/devops_key.pub")
}

# Creating AWS S3
resource "aws_s3_bucket" "jenkins_artifacts" {
    bucket = "bilous-jenkins-build-artifacts"
    tags = {
      "Name" = "DevOps"
    }

    # Destroying bucket even with content inside
    force_destroy = true
}

# Creating AWS EC2
resource "aws_instance" "ec2_jenkins" {
    ami = "ami-0b5eea76982371e91"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.ec2_group.id ]
    key_name = aws_key_pair.ssh_key.key_name
    tags = {
        Name = "DevOps"
        OS = "Amazon Linux"
    }

    # Providing script that installs Docker with Jenkins using given config files
    user_data = base64encode(templatefile("${path.module}/../docker/ec2_setup.sh", {
        DOCKERFILE = file("${path.module}/../docker/Dockerfile")
        PLUGINS = file("${path.module}/../jenkins/plugins.txt")
        SEEDJOB = file("${path.module}/../jenkins/seedjob.groovy")
        CASC = templatefile("${path.module}/../jenkins/casc.yaml", {
            JKS_ID = var.jenkins_username
            JKS_PWD = var.jenkins_password
            AWS_ACCESS_KEY = var.aws_api_key
            AWS_SECRET_ACCESS_KEY = var.aws_api_secret
        })
    }))

    # Making sure EC2 is created after Security Group and S3
    depends_on = [
        aws_security_group.ec2_group,
        aws_s3_bucket.jenkins_artifacts
    ]
}


# Printing EC2 public IP after setup completes
output "ec2_public_ip" {
    value = aws_instance.ec2_jenkins.public_ip
}

# Printing EC2 DNS after setup completes
output "ec2_public_dns" {
  value = aws_instance.ec2_jenkins.public_dns
}
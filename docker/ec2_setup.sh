#! /bin/bash
# Updating OS packages and installing Docker
sudo yum update -y
sudo yum install -y docker

# Starting Docker
sudo service docker start

# Setting up Docker service to start after each reboot
sudo systemctl enable docker

# Appending a new Docker group to use Docker commands without sudo
sudo usermod -a -G docker ec2-user

# Moving to user home folder where all setup scripts will be located
cd /home/ec2-user

# Creating setup scripts with content from passed variables
echo "${DOCKERFILE}" > Dockerfile
echo "${CASC}" > casc.yaml
echo "${PLUGINS}" > plugins.txt
echo "${SEEDJOB}" > seedjob.groovy

# Building tagged Docker image using Dockerfile
docker build -t jenkins:devops .

# Starting Docker container with Jenkins in background with open STDIN and pseudoTTY
docker run -dit --name jenkins -p 8080:8080 jenkins:devops
# Declaring variables

variable "aws_api_key" {
    type = string
    description = "An API key for AWS IAM user"
    # Flag used to limit Terraform UI output when the variable is used in configuration
    sensitive = true
}

variable "aws_api_secret" {
    type = string
    description = "An API secret for AWS IAM user"
    # Flag used to limit Terraform UI output when the variable is used in configuration
    sensitive = true
}

variable "jenkins_username" {
    type = string
    description = "Username for Jenkins admin user"
    # Flag used to limit Terraform UI output when the variable is used in configuration
    sensitive = true
}

variable "jenkins_password" {
    type = string
    description = "Password for Jenkins admin user"
    # Flag used to limit Terraform UI output when the variable is used in configuration
    sensitive = true
}
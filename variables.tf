variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "ssh_private_key" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "ssh_key_private" {
    description = "private key path"
    default = "key-name.pem"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-0947d2ba12ee1ff75" 
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "192.168.1.0/24"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "192.168.1.0/25"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "192.168.1.128/25"
}

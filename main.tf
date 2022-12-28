provider "aws" {
    region = "eu-west-3"
    access_key = ""
    secret_key = ""
}

variable "subnet_cidr_block" {
  description = "subnet_cidr_block"
}

variable "vpc_cidr_block" {
  description = "vpc_cidr_block"
}

variable "environment" {
    description = "deployment environment"
}

resource "aws_vpc" "development-vpc" { 
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "development",
        vpc-env: "dev"
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "es-west-3a"
    tags = {
        Name: "subnet-1-dev"
    }
}

data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.48.0/20"
    availability_zone = "eu-west-3a"
    tags = {
        Name: "subnet-2-defaults"
    }
}

output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
}


output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}
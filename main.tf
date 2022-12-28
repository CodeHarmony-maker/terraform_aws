provider "aws" {
    # region = "eu-west-3"
    # access_key = ""
    # secret_key = ""
}

variable "subnet_cidr_block" {
  description = "subnet_cidr_block"
  default = "10.0.10.0/24"
}

variable "cidr_blocks" {
    description = "cidr block for vpc and subnets"
    type = list(string)
}

variable "cidr_block_objects" {
    description = "cidr block and name tags for vpc and subnets"
    type = list(object({
        cidr_block = string
        name = string
    }))
}

variable "vpc_cidr_block" {
  description = "vpc_cidr_block"
}

variable "environment" {
    description = "deployment environment"
}

variable "avail_zone" {}

resource "aws_vpc" "development-vpc-object" { 
    cidr_block = var.cidr_block_objects[0].cidr_block
    tags = {
        Name: var.cidr_block_objects[0].name
        vpc-env: "dev"
    }
}

resource "aws_subnet" "dev-subnet-object" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_block_objects[1].cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: var.cidr_block_objects[10].name
    }
}

resource "aws_vpc" "development-vpc" { 
    cidr_block = var.cidr_block[0]
    tags = {
        Name: "development",
        vpc-env: "dev"
    }
}

resource "aws_subnet" "dev-subnet-0" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_block[1]
    availability_zone = "es-west-3a"
    tags = {
        Name: "subnet-0-dev"
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
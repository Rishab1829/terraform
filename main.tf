provider "aws" {
    region = "ap-south-1"
    #SECRET KEY ID AND ACCESS KEY ID configured in in aws credentials file 
}

variable "res-object" {
  description = "cidr_blocks and names for my-vpc and my-subnet-1"
  type = list(object({                                     
      cidr_block = string
      name = string
  }))                                                      #specifying object type and attributes type inside of object
}
resource "aws_vpc" "my-vpc" {
    cidr_block = var.res-object[0].cidr_block              #referencing the cidr_block for VPC from res-object
    tags = {
        Name: "var.res-obj[0].name"                        #referencing the name for VPC from res-object
    }
}

resource "aws_subnet" "my-subnet-1" {
    vpc_id = aws_vpc.my-vpc.id                             #referencing vpc id through vpc resource
    cidr_block = var.res-object[1].cidr_block              #referencing the cidr_block for subnet from res-object
    availability_zone = "ap-south-1a"
    tags = {
        Name: "var.res-obj[1].name"                        #referencing the name for subnet from res-object
    }
}
# Data Sources allows data to be fetched for use in TF configuration
data "aws_vpc" "existing_vpc"{
    default = "true"                                      #Search criteria : vpc that needs to be searched
}

resource "aws_subnet" "default_subnet-1" {                 #creating a subnet for default vpc
    vpc_id = data.aws_vpc.existing_vpc.id                  #referencing data source query
    cidr_block = "172.31.48.0/20"
    availability_zone =  "ap-south-1a"
}

output "my-vpc-id" {                                       #outputs the vpc_id of my_vpc created 
  value = aws_vpc.my-vpc.id
}

output "my-subnet-1-id" {
  value = aws_subnet.default_subnet-1.id
}


provider "aws" {
    version = "~> 3.0" # what is my version?
    region = "us-west-2"
}

provider "aws" {
    alias = "east"
    region = "us-east-1"
}

locals {
    setup_name = "Rachels"
}

# data source from aws instance get the vpc named vpc_name and set as default
data "aws_vpc" "vpc_name" {
    default = true
}

data "aws_ami" "ami_name" {
    owners = ['self'] # current aws account
    most_recent = true # returns most recently created
}

# create basic EC2
resource "aws_instance" "name" {
    provider = aws
    count = 2 # create 2 instances
    ami = "ami-02342034832948023" # machine image name
    ami = data.aws_ami.ami_name
    instance_type = "t2.medium"

    tags = var.instance_tags
    tags = {
        Name = "Test ${count.index}" # name the (2) instances
        foo = local.setup_name == "rachel" ? "yes" : "no"
    }
    lifecycle {
        create_before_destroy = true # may need to use if err cannot destroy .. ect
        # prevent_destroy = true
        # ignore_changes = [{tags}] # could ignore changes from UI pulled into terraform state here
    }
}

# create additional EC2 
resource "aws_instance" "name-two" {
    provider = aws.east
    ami = "some ami from aws ui in correct region"
    tage = {
        Name = "east test"
    }
}

# create vpc and call it main
resource "aws_vpc" "main" {
    tags = "${local.setup_name}-vpc"
    foo = local.setup_name
}

# create subnet
resource "aws_subnet" "web" {
    vpc_id = data.aws_vpc.vpc_name.id # using existing vpc from data resource
    cidr_block = "10.0.0.0/16"
}

/* 

IaC_Administration needs to be used, never use your aws credentials for terraform single remote state

SSO > AWS Accounts >  AssumeOrMartinezTerraformCi
The role is able to be given to anyone



*/
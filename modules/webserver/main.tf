provider "aws" {
    region = "us-west-2"
}

resource "aws_vpc_main" {
    cidr_block = "10.0.0.0/16"
}

module "rachels_webserver" {
    source = "../modules/webserver"
}
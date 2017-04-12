#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-eea9f38e
#
# Your subnet ID is:

#     subnet-7e08481a
#
# Your security group ID is:
#
#     sg-834d35e4
#
# Your Identity is:
#
#     autodesk-spider
#

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "us-west-1"
}

variable "count" {
  default = "3"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami                    = "ami-eea9f38e"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-7e08481a"
  vpc_security_group_ids = ["sg-834d35e4"]
  count                  = "${var.count}"

  tags {
    Identity = "autodesk-spider"
    Name     = "web ${count.index+1}/${var.count}"
    Group    = "autodesk-terraform-trainning"
  }
}

terraform {
  backend "atlas" {
    name = "shirleyxie/training"
  }
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}

output "ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

data "terraform_remote_state" "tfstate" {
  backend = "s3"
  config {
    bucket =  "myterraform-scripts"
    key = "terraform/terraform-tfstate"
    region  = "us-east-1"
  }
}

resource "aws_vpc" "main" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = true

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-vpc"
    },
  )
}

resource "aws_security_group" "jenkings_sg" {
  name = "sg_${var.jenkings_name}"
  description = "Allow Jenkings SG"
  vpc_id = "var.vpc_id"

  ingress {
    description = "Allow ssh access"
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [var.cidr_block]
  }
  ingress {
    description = "Allow personal CIDR block"
    from_port = 8080
    protocol  = "tcp"
    to_port   = 8080
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    description = "Allow personal CIDR block"
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    description = "Allow 443 access"
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = [var.cidr_block]
  }

  egress {
    description = "Allow outside access"
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    name = "Jenkings SG"
  }

}


data "template_file" "user_data" {
  template = "${file("template/user_data.tpl")}"
}

resource "aws_instance" "jenkings_ec2" {
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.jenkings_sg}"]
  ami = "${lookup(var.amis, var.region)}"
  key_name = "${var.key_name}"
  user_data = "${data.template_file.user_data.rendered}"

  tags = {
    name  = "${var.jenkings_name}"
  }
}

#add backup task to crontab
provisioner "file" {
    connection {
      user = "ec2-user"
      host =  "${aws_instance.jenkings_ec2.public_ip}"
      timeout = "1m"
      private_key = "${file("${var.key_name}.pem")}"
    }
  source = "template/cron.sh"
  destination = "/home/ec2-user/cron.sh"
}

provisioner "remote-exec" {
  connection {
    user = "ec2-user"
    host = "${aws_instance.jenkings_ec2.public_ip}"
    timeout = "1m"
    private_key = "${file("${var.key_name}.pem")}"
  }
  inline = [
    "chmod +x /home/ec2-user/cron.sh"
    "/home/ec2-user/cron.sh ${var.access_key} ${var.secret_key} ${var.s3_bucket} ${var.jenkings_name}"
  ]
}
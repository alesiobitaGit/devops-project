variable "access_key" {
  description = "The aws access key"
}

variable "secret_key" {
  description = "the aws secret key"
}

variable "region" {
  description = "aws region"
  default = "us-east-1"
}

variable "availability_zone" {
  description = "availability_zone"
  default = "us-east-1a"
}

variable "jenkings_name" {
  description = "jenkings server"
  default = "jenkings_ec2"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the Weave ECS AMIs: https://github.com/weaveworks/integrations/tree/master/aws/ecs."
  default = {
    us-east-1 = "ami-49617b23"
    us-west-1 = "ami-24057b44"
    us-west-2 = "ami-3cac5c5c"
    eu-west-1 = "ami-1025aa63"
    eu-central-1 = "ami-e010f38f"
    ap-northeast-1 = "ami-54d5cc3a"
    ap-southeast-1 = "ami-664d9905"
    ap-southeast-2 = "ami-c2e9c4a1"
  }
}

variable "instance_type" {
  description = "ec2 instance"
  default = "t2.micro"
}

variable "key_name" {
  description = "ssh of aws acc"
  default = "jenkings"
}

variable "s3_bucket" {
  description = "s3 bucket"
  default = "myterraform-scripts"
}

variable "vpc_id" {}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

ariable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  type        = bool
  default     = false
}
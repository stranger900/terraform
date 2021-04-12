
variable "public_subnet_cidrs" {} #default = ["10.0.1.0/24", "10.0.2.0/24"]

variable "private_subnet_cidrs" {} # default = ["10.0.50.0/24", "10.0.51.0/24"]

variable "vpc_cidr_block" {} #default = "10.0.0.0/16"

variable "sg_cidr_blocks" {}

variable "sg_ports" {}

variable "public_1_cidr_block" {}

variable "public_2_cidr_block" {}

variable "private_1_cidr_block" {}

variable "private_2_cidr_block" {}

variable "ami_type" {}

variable "disk_size" {}

variable "instance_types" {}

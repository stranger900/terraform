module "vpc" {
  source           = "./modules/vpc"
  vpc_cidr_block   = var.vpc_cidr_block
  subnet_public_1  = module.subnets.aws_subnet_public_1_id
  subnet_public_2  = module.subnets.aws_subnet_public_2_id
  subnet_private_1 = module.subnets.aws_subnet_private_1_id
  subnet_private_2 = module.subnets.aws_subnet_private_2_id
}

module "security_group" {
  source         = "./modules/sg"
  vpc            = module.vpc.vpc_id
  sg_cidr_blocks = var.sg_cidr_blocks
  sg_ports       = var.sg_ports
}

module "subnets" {
  source               = "./modules/subnets"
  vpc_id               = module.vpc.vpc_id
  public_1_cidr_block  = var.public_1_cidr_block
  public_2_cidr_block  = var.public_2_cidr_block
  private_1_cidr_block = var.private_1_cidr_block
  private_2_cidr_block = var.private_2_cidr_block
}

module "eks" {
  source           = "./modules/eks"
  subnet_public_1  = module.subnets.aws_subnet_public_1_id
  subnet_public_2  = module.subnets.aws_subnet_public_2_id
  subnet_private_1 = module.subnets.aws_subnet_private_1_id
  subnet_private_2 = module.subnets.aws_subnet_private_2_id
  ami_type         = var.ami_type
  disk_size        = var.disk_size
  instance_types   = var.instance_types
}

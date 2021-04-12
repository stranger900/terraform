output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "aws_subnet_private_1_id" {
  value = module.subnets.aws_subnet_private_1_id
}

output "aws_subnet_private_2_id" {
  value = module.subnets.aws_subnet_private_2_id
}

output "aws_subnet_public_1_id" {
  value = module.subnets.aws_subnet_public_1_id
}

output "aws_subnet_public_2_id" {
  value = module.subnets.aws_subnet_public_2_id
}

output "endpoint" {
  value = module.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = module.eks.kubeconfig-certificate-authority-data
}

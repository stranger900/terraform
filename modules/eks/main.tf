
#========================= EKS ==============================
#============= Role & Policy
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.id
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.id
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

#============ EKS === EKS aws_eks_cluster

resource "aws_eks_cluster" "eks" {
  name     = "eks"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = false

    subnet_ids = [
      var.subnet_public_1,  #aws_subnet.public_1.id,
      var.subnet_public_2,  #aws_subnet.public_2.id,
      var.subnet_private_1, #aws_subnet.private_1.id,
      var.subnet_private_2, #aws_subnet.private_1.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster-policy
  ]
}

#========================== EKS node group roles ===================

resource "aws_iam_role" "nodes_group" {
  name = "eks-nodes-group"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_group.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_group.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_group.name
}

#========================== EKS node group ==================

resource "aws_eks_node_group" "nodes_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "nodes_group"
  node_role_arn   = aws_iam_role.nodes_group.arn
  subnet_ids = [
    var.subnet_private_1, #aws_subnet.private_1.id,
    var.subnet_private_2  #aws_subnet.private_2.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }
  ami_type             = var.ami_type
  disk_size            = var.disk_size
  instance_types       = var.instance_types
  force_update_version = false

  labels = {
    role = "nodes_group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_readonly,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

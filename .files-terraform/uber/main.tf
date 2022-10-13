module "vpc" {

    source              = "/home/oche/project-uber/.files-terraform/modules/vpc"
    project-name        = var.project-name
    vpc-cidr            = var.vpc-cidr
    priv1a-cidr         = var.priv1a-cidr
    pub1b-cidr          = var.pub1b-cidr
    priv2a-cidr         = var.priv2a-cidr
    pub2b-cidr          = var.pub2b-cidr
    eks-cluster         = var.eks-cluster

}



#create ecr registry to store credentials
resource "aws_ecr_repository" "uber-repo" {
  name                 = var.repo-name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Name = "${var.project-name}-repo"
  }
}

#create a k8s cluster

#read cluster policy role to allow cluster communicate with other services like load balancing e.t.c
data "aws_iam_role" "eks-cluster-role" {
  name = var.eks-role
}


#create an amazon eks cluster
resource "aws_eks_cluster" "uber-cluster" {
  name     = var.eks-clustername
  role_arn = data.aws_iam_role.eks-cluster-role.arn

  vpc_config {
    subnet_ids = [ module.vpc.private_subnet_2a, module.vpc.private_subnet_1a ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    data.aws_iam_role.eks-cluster-role
  ]

  tags = {
    Name = "${var.project-name}-cluster"
  }
}




#read eks pod role 
data "aws_iam_role" "eks-noderole" {
  name = var.eks-noderole
}

#create node group
resource "aws_eks_node_group" "uber-nodegroup" {
  cluster_name    = aws_eks_cluster.uber-cluster.name
  node_group_name = var.node-name
  node_role_arn   = data.aws_iam_role.eks-noderole.arn
  subnet_ids      = [ module.vpc.public_subnet_1a, module.vpc.public_subnet_2a ]
  instance_types = [ var.instance-type ] 
  ami_type = var.ami-type
  disk_size = var.disk-size



  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    /*aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,*/
    data.aws_iam_role.eks-noderole

  ]
}
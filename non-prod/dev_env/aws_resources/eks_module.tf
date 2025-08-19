module "eks" {
  source       = "../../../modules/AWS_EKS"
  vpc_name     = var.vpc_name
  region       = var.region
  cidr_block   = var.cidr_block
  tags         = var.tags
  cluster_name = var.cluster_name
  eks_version  = var.eks_version
}

###########
####
#####
##########

############
###########
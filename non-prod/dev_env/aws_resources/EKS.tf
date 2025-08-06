module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = module.vpc.private_subnets

  # Use the new authentication mode
  authentication_mode = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true
  
  # Enable public access for GitHub Actions
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  
  enable_irsa = true
  vpc_id = module.vpc.vpc_id

  

  # Use access entries instead of aws-auth ConfigMap
  access_entries = {
    github_actions = {
      kubernetes_groups = []
      principal_arn    = "arn:aws:iam::242201309386:role/git-hub-action_aws_resources"
      
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }


  eks_managed_node_group_defaults = {
        ami_type = "AL2_x86_64"
    }

  eks_managed_node_groups = {
    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
      instance_types = [var.instance_type]
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
    }
  }

  tags = {
    cluster = "demo"
  }
}
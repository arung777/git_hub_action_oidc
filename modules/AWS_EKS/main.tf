#######VPC CREATION

data "aws_availability_zones" "available" {
  state = "available"
}

##VPC
resource "aws_vpc" "demo-eks-cluster-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags                 = var.tags
}

locals {
  additional_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.demo-eks-cluster-vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 10)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = var.tags
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.demo-eks-cluster-vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 20)
  availability_zone = data.aws_availability_zones.available.names[1]
  tags              = var.tags
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.demo-eks-cluster-vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 110)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = merge(var.tags, local.additional_tags)
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.demo-eks-cluster-vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 120)
  availability_zone = data.aws_availability_zones.available.names[1]
  tags              = merge(var.tags, local.additional_tags)
}

resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.demo-eks-cluster-vpc.id
  tags   = var.tags
}

resource "aws_eip" "eks-ngw-eip" {
  domain     = "vpc"
  tags       = var.tags
  depends_on = [aws_internet_gateway.eks-igw]
}

resource "aws_nat_gateway" "eks-ngw" {
  allocation_id = aws_eip.eks-ngw-eip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  depends_on = [aws_internet_gateway.eks-igw]
  tags       = var.tags
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.demo-eks-cluster-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }
  tags = var.tags
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.demo-eks-cluster-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks-ngw.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "public-rt-assoc-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-rt-assoc-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-rt-assoc-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-rt-assoc-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}





#######EKS CLUSTER CREATION #######################

resource "aws_iam_role" "demo-eks-cluster-role" {
  name               = "demo-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo-eks-cluster-role.name
}

resource "aws_eks_cluster" "demo-eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.demo-eks-cluster-role.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids = [
      aws_subnet.private-subnet-1.id,
      aws_subnet.private-subnet-2.id,
      aws_subnet.public-subnet-1.id,
      aws_subnet.public-subnet-2.id
    ]
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  bootstrap_self_managed_addons = true
  tags                          = var.tags
  version                       = var.eks_version

  upgrade_policy {
    support_type = "STANDARD"
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_eks_access_entry" "devops_arung" {
  cluster_name      = aws_eks_cluster.demo-eks-cluster.name
  principal_arn     = "arn:aws:iam::242201309386:user/Devops-ArunG"
  kubernetes_groups = []
}

resource "aws_eks_access_policy_association" "devops_arung_admin_policy" {
  cluster_name  = aws_eks_cluster.demo-eks-cluster.name
  principal_arn = aws_eks_access_entry.devops_arung.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.devops_arung]
}


############### node group creation #######################




resource "aws_iam_role" "demo-eks-ng-role" {
  name               = "demo-eks-node-group-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-demo-ng-WorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.demo-eks-ng-role.name
}

resource "aws_iam_role_policy_attachment" "eks-demo-ng-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.demo-eks-ng-role.name
}

resource "aws_iam_role_policy_attachment" "eks-demo-ng-ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.demo-eks-ng-role.name
}

resource "time_sleep" "wait_for_eks_cluster" {
  depends_on      = [aws_eks_cluster.demo-eks-cluster]
  create_duration = "120s"
}



##Node Group Creation
resource "aws_eks_node_group" "eks-demo-node-group" {
  cluster_name    = var.cluster_name
  instance_types  = ["t3.medium"]
  ami_type        = "AL2_x86_64"
  node_role_arn   = aws_iam_role.demo-eks-ng-role.arn
  node_group_name = "demo-eks-node-group"
  subnet_ids = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    time_sleep.wait_for_eks_cluster,
    aws_iam_role_policy_attachment.eks-demo-ng-WorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-demo-ng-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-demo-ng-ContainerRegistryReadOnly,
  ]
}



########Fargate Profile Creation #######################

resource "aws_iam_role" "demo-eks-fargate-profile-role" {
  name               = "demo-eks-fargate-profile-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect  = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "fargate-execution-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.demo-eks-fargate-profile-role.name
}

resource "aws_eks_fargate_profile" "demo-eks-fg-prof" {
  cluster_name           = aws_eks_cluster.demo-eks-cluster.name
  fargate_profile_name   = "demo-eks-fargate-profile-1"
  pod_execution_role_arn = aws_iam_role.demo-eks-fargate-profile-role.arn

  selector {
    namespace = "kube-system"
  }
  selector {
    namespace = "default"
  }

  subnet_ids = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id
  ]

  depends_on = [aws_iam_role_policy_attachment.fargate-execution-policy]
}






########ArgoCD Installation #######################
data "aws_eks_cluster" "demo" {
  name = aws_eks_cluster.demo-eks-cluster.name
}

data "aws_eks_cluster_auth" "demo" {
  name = data.aws_eks_cluster.demo.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.demo.endpoint
  token                  = data.aws_eks_cluster_auth.demo.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo.certificate_authority[0].data)
}
provider "helm" {
  kubernetes  {
    host                   = data.aws_eks_cluster.demo.endpoint
    token                  = data.aws_eks_cluster_auth.demo.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo.certificate_authority[0].data)
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.6"
  namespace        = "argocd"
  create_namespace = true
  timeout          = 1200
  


  set  {
      name  = "server.service.type"
      value = "LoadBalancer"
    }
  set  {
      name  = "server.service.annotations.\"service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal\""
      value = "true"
    }
  # set  {
  #     name  = "controller.replicas"
  #     value = "1"
  #   }
  # set  {
  #     name  = "server.replicas"
  #     value = "1"
  #   }
  # set  {
  #     name  = "repoServer.replicas"
  #     value = "1"
  #   }
  # set  {
  #     name  = "applicationSet.replicaCount"
  #     value = "1"
  #   }
  # set  {
  #     name  = "server.resources.requests.cpu"
  #     value = "100m"
  #   }
  # set  {
  #     name  = "server.resources.requests.memory"
  #     value = "128Mi"
  #   }
  #############
  ###########

  depends_on = [
    aws_eks_cluster.demo-eks-cluster,
    aws_eks_node_group.eks-demo-node-group
  ]
}

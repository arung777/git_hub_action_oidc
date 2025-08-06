resource "aws_iam_role" "demo-eks-cluster-role" {
name = "demo-eks-cluster-role"
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
    name = var.cluster_name
    role_arn = aws_iam_role.demo-eks-cluster-role.arn
    vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = [
        aws_subnet.private-subnet-1.id,
        aws_subnet.private-subnet-2.id,
        aws_subnet.public-subnet-1.id,
        aws_subnet.public-subnet-2.id
    ]
    }
    access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
    }
    bootstrap_self_managed_addons = true
    tags = var.tags
    version = var.eks_version
    upgrade_policy {
    support_type = "STANDARD"
    }
    depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
}

resource "aws_eks_access_entry" "devops_arung" {
  cluster_name      = aws_eks_cluster.demo-eks-cluster.name
  principal_arn     = "arn:aws:iam::242201309386:user/Devops-ArunG"
  kubernetes_groups = [] # or specify groups if needed
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

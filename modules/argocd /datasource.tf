data "aws_eks_cluster" "demo-eks-cluster" {
  name = aws_eks_cluster.demo-eks-cluster.name # replace with your EKS cluster name or use output of aws_eks_cluster resource
}

data "aws_eks_cluster_auth" "demo-eks-cluster-auth" {
  name = data.aws_eks_cluster.demo-eks-cluster.name
}
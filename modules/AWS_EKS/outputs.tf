output "cluster_id" {
  description = "EKS cluster ID."
  value       = aws_eks_cluster.demo-eks-cluster.id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = aws_eks_cluster.demo-eks-cluster.endpoint
}

output "cluster_security_group_id" {
  description = "Cluster control plane security group ID"
  value       = aws_eks_cluster.demo-eks-cluster.vpc_config[0].cluster_security_group_id
}

output "vpc_id" {
  description = "VPC ID for the EKS cluster"
  value       = aws_vpc.demo-eks-cluster-vpc.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
}

output "argocd_admin_password_cmd" {
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
  description = "Run this command after apply to get Argo CD initial admin password"
}

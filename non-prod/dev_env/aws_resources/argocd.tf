# # Data sources to fetch your EKS cluster info (adjust the cluster name if needed)
# data "aws_eks_cluster" "demo-eks-cluster" {
#   name = aws_eks_cluster.demo-eks-cluster.name
# }

# data "aws_eks_cluster_auth" "demo-eks-cluster-auth" {
#   name = data.aws_eks_cluster.demo-eks-cluster.name
# }

# # Kubernetes provider setup for Helm
# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.demo-eks-cluster.endpoint
#   token                  = data.aws_eks_cluster_auth.demo-eks-cluster-auth.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo-eks-cluster.certificate_authority[0].data)
# }

# # Helm provider configuration (do not use a kubernetes block here!)
# provider "helm" {
# #     kubernetes = {
# #             config_path = "~/.kube/config"
# #   }
# }

# # Install Argo CD with internal Load Balancer for UI (private, secure, minimum resources)
# resource "helm_release" "argocd" {
#   name             = "argocd"
#   repository       = "https://argoproj.github.io/argo-helm"
#   chart            = "argo-cd"
#   version          = "5.51.6"
#   namespace        = "argocd"
#   create_namespace = true

#   depends_on = [ aws_eks_cluster.demo-eks-cluster.name ]
#   set {
#     name  = "server.service.type"
#     value = "LoadBalancer"
#   }

#   set {
#     name  = "server.service.annotations.\"service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal\""
#     value = "true"
#   }

# #   set {
# #     name  = "controller.replicas"
# #     value = "1"
# #   }
# #   set {
# #     name  = "server.replicas"
# #     value = "1"
# #   }
# #   set {
# #     name  = "repoServer.replicas"
# #     value = "1"
# #   }
# #   set {
# #     name  = "applicationSet.replicaCount"
# #     value = "1"
# #   }
# #   set {
# #     name  = "server.resources.requests.cpu"
# #     value = "100m"
# #   }
# #   set {
# #     name  = "server.resources.requests.memory"
# #     value = "128Mi"
# #   }
# }

# output "argocd_admin_password_cmd" {
#   value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
#   description = "Run this command to get the Argo CD initial admin password"
# }
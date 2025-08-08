# resource "null_resource" "update_kubeconfig" {
#   provisioner "local-exec" {
    
#     command = "aws eks update-kubeconfig --region ${var.region} --name ${var.cluster_name}"
#   }

#   depends_on = [
#     aws_eks_cluster.demo-eks-cluster,
#     aws_eks_node_group.eks-demo-node-group
#   ]
# }


# 1. Fetch cluster info and auth token for Terraform providers
data "aws_eks_cluster" "demo" {
  name =  aws_eks_cluster.demo-eks-cluster.name # Replace with your EKS cluster name or use aws_eks_cluster resource output
}

data "aws_eks_cluster_auth" "demo" {
  name = data.aws_eks_cluster.demo.name
}

# 2. Kubernetes provider to communicate with EKS
provider "kubernetes" {
  host                   = data.aws_eks_cluster.demo.endpoint
  token                  = data.aws_eks_cluster_auth.demo.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo.certificate_authority[0].data)
}

# 3. Helm provider to install Helm charts into the Kubernetes cluster
provider "helm" {
    kubernetes =  {
        host                   = data.aws_eks_cluster.demo.endpoint
        token                  = data.aws_eks_cluster_auth.demo.token
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo.certificate_authority[0].data)
    }
}

# 4. Helm release resource to install Argo CD
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.6"   # Pin to a stable version; update as needed
  namespace        = "argocd"
  create_namespace = true
  timeout          = 1200

  set = [
    {
      name  = "server.service.type"
      value = "LoadBalancer"
    },
   {
      name  = "server.service.annotations.\"service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal\""
      value = "true"
    },
    {
      name  = "controller.replicas"
      value = "1"
    },
    {
      name  = "server.replicas"
      value = "1"
    },
   {
      name  = "repoServer.replicas"
      value = "1"
    },
   {
      name  = "applicationSet.replicaCount"
      value = "1"
    },
   {
      name  = "server.resources.requests.cpu"
      value = "100m"
    },
    {
      name  = "server.resources.requests.memory"
      value = "128Mi"
    }
  ]
   depends_on = [
    # null_resource.update_kubeconfig,  # Ensure kubeconfig is updated before installing Argo CD
    aws_eks_cluster.demo-eks-cluster,
    aws_eks_node_group.eks-demo-node-group
  ]
}

# 5. Output command to get Argo CD admin password easily after deployment
output "argocd_admin_password_cmd" {
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
  description = "Run this command after apply to get Argo CD initial admin password"
}

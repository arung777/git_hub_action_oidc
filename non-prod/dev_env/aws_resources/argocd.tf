# 1. Fetch cluster info and auth token for Terraform providers
data "aws_eks_cluster" "demo-eks-cluster" {
  name =  var.cluster_name # Replace with your EKS cluster name or use aws_eks_cluster resource output
}

data "aws_eks_cluster_auth" "demo-eks-cluster-auth" {
  name = data.aws_eks_cluster.demo-eks-cluster.name
}

# 2. Kubernetes provider to communicate with EKS
provider "kubernetes" {
  host                   = data.aws_eks_cluster.demo-eks-cluster.endpoint
  token                  = data.aws_eks_cluster_auth.demo-eks-cluster-auth.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo-eks-cluster.certificate_authority[0].data)
}

# 3. Helm provider to install Helm charts into the Kubernetes cluster
provider "helm" {
#   kubernetes = {
#     config_path = "~/.kube/config"  # Optional; if your kubeconfig is properly set, you can omit this.
#   }
}

# 4. Helm release resource to install Argo CD
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.6"   # Pin to a stable version; update as needed
  namespace        = "argocd"
  create_namespace = true
  timeout          = 600

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
}

# 5. Output command to get Argo CD admin password easily after deployment
output "argocd_admin_password_cmd" {
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
  description = "Run this command after apply to get Argo CD initial admin password"
}

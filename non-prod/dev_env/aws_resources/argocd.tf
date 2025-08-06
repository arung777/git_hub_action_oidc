data "aws_eks_cluster" "demo-eks-cluster" {
  name = aws_eks_cluster.demo-eks-cluster.name
}

data "aws_eks_cluster_auth" "demo-eks-cluster-auth" {
  name = data.aws_eks_cluster.demo-eks-cluster.name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.demo-eks-cluster.endpoint
    token                  = data.aws_eks_cluster_auth.demo-eks-cluster-auth.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo-eks-cluster.certificate_authority[0].data)
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.6"
  namespace        = "argocd"
  create_namespace = true

  # Deploy the Argo CD UI as an internal AWS Load Balancer (cheaper, not public)
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "server.service.annotations.\"service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal\""
    value = "true"
  }

  # Reduce Argo CD resource consumption for test/dev:
  set {
    name  = "controller.replicas"
    value = "1"
  }
  set {
    name  = "server.replicas"
    value = "1"
  }
  set {
    name  = "repoServer.replicas"
    value = "1"
  }
  set {
    name  = "applicationSet.replicaCount"
    value = "1"
  }
  # Using small pod resources for minimal cost
  set {
    name  = "server.resources.requests.cpu"
    value = "100m"
  }
  set {
    name  = "server.resources.requests.memory"
    value = "128Mi"
  }
}

# Output the command to get the Argo CD admin password
output "argocd_admin_password_cmd" {
  value = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}



resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.6"
  namespace        = "argocd"
  create_namespace = true
  timeout          = 600

  # Use an INTERNAL LoadBalancer to access ArgoCD UI only inside the VPC
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "server.service.annotations.\"service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal\""
    value = "true"
  }
  # Minimal resource requests for control plane
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
  set {
    name  = "server.resources.requests.cpu"
    value = "100m"
  }
  set {
    name  = "server.resources.requests.memory"
    value = "128Mi"
  }
}

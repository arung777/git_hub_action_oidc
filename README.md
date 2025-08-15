#### git_hub_action_oidc

Goal : 
  Creating the aws resources using terraform 

#### important Terraform Commands 

  Terraform init
  terraform validate 
  terraform plan 
  terraform apply --auto-approve
  terraform destroy


#### Connecting aws EKS cluster 

    aws configure

    aws eks update-kubeconfig --region <region> --name <cluster_name>

#### important Kubernetes Command

  kubectl get pods -n argocd
  kubectl get nodes 
  kubectl get svc -n argocd
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  kubectl port-forward svc/argocd-server -n argocd 8080:443

  python deployment : 
    kubectl port-forward service/python-simple-app-service 8081:80 -n default


#### Argo CD important commands 
  to get the EKS cluster ENd point 
    aws eks describe-cluster --name YOUR_CLUSTER_NAME --query "cluster.endpoint" --output text
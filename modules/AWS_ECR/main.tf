resource "aws_ecr_repository" "terraform_ecr_repo" {
  name                 = var.name_of_repository
  image_tag_mutability = var.tag_setting

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}


output "url_of_ecr_repository" {
  value       = aws_ecr_repository.terraform_ecr_repo.repository_url
  description = "URL of the ECR repository created"
  
}




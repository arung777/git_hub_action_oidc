# module "aws_ecr_repository" {
#     source = "../../../modules/AWS_ECR"
    
#     name_of_repository = var.name_of_repository
#     tag_setting         = var.tag_setting
#     scan_on_push        = var.scan_on_push
#     aws_region          = var.aws_region
#     aws_access_key      = var.aws_access_key
#     secret_key          = var.secret_key
  
# }
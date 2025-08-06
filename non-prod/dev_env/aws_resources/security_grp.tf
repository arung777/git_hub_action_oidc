
# resource "aws_security_group" "all_worker_mgmt" {
#   name_prefix = "all_worker_management"
#   vpc_id      = module.vpc.vpc_id
# }

# resource "aws_security_group_rule" "all_worker_mgmt_ingress" {
#   description       = "allow inbound traffic from eks"
#   from_port         = 0
#   protocol          = "-1"
#   to_port           = 0
#   security_group_id = aws_security_group.all_worker_mgmt.id
#   type              = "ingress"
#   cidr_blocks = [
#     "10.0.0.0/8",
#     "172.16.0.0/12",
#     "192.168.0.0/16",
#   ]
# }

# resource "aws_security_group_rule" "all_worker_mgmt_egress" {
#   description       = "allow outbound traffic to anywhere"
#   from_port         = 0
#   protocol          = "-1"
#   security_group_id = aws_security_group.all_worker_mgmt.id
#   to_port           = 0
#   type              = "egress"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# #Creating IAM role for EKS Node Group and attaching policies
# resource "aws_iam_role" "node_group_role" {
#   name = "eks-node-group-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.node_group_role.name
# }

# resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.node_group_role.name
# }

# resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.node_group_role.name
# }
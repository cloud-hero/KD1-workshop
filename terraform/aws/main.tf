provider "aws" {
  region = "eu-central-1"
}  

# module "andrei_petrescu_k8s" {
#   source                = "./modules/k8s_onprem"
#   no_masters            = 3
#   no_workers            = 2
#   ami                   = "ami-04f9a173520f395dd"
#   instance_type         = "t3.medium"
#   project_name          = "veolia-workshop"
#   instance_name         = "andrei-petrescu"
#   subnet_id             = "subnet-0d37f38635cc31cbd"
#   vpc_id                = "vpc-00c63dd20cf9381f7"
# }

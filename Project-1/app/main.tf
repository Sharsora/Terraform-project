# creating VPC
module "vpc" {
  source           = "../modules/vpc"
  region           = var.region
  project_name     = var.project_name
  vpc_cidr        = var.vpc_cidr
  PUB_SUB_1_A_CIDR = var.PUB_SUB_1_A_CIDR
  PUB_SUB_2_B_CIDR = var.PUB_SUB_2_B_CIDR
  PRI_SUB_3_A_CIDR = var.PRI_SUB_3_A_CIDR
  PRI_SUB_4_B_CIDR = var.PRI_SUB_4_B_CIDR
  PRI_SUB_5_A_CIDR = var.PRI_SUB_5_A_CIDR
  PRI_SUB_6_B_CIDR = var.PRI_SUB_6_B_CIDR
}

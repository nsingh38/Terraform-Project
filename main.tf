# Calling module
module "vpc1" {
  source = "./modules/VPC"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  subnet_az           = var.subnet_az
}

module "autoscaling" {
  source = "./modules/Autoscaling"

  vpc_id             = module.vpc1.vpc_id
  private_subnets_id = module.vpc1.private_subnets_id
  tg-arn             = module.loadbalancer.tg-arn
}

module "loadbalancer" {
  source = "./modules/Load-Balancer"

  vpc_id            = module.vpc1.vpc_id
  public_subnets_id = module.vpc1.public_subnets_id
}

module "route53" {
  source = "./modules/Route53"

  eip = module.vpc1.eip
}

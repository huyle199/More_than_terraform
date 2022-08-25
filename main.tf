#Root Main.tf
module "networking"{
  source = "./networking"
  vpc_cidr = local.vpc.cidr
  access_ip = var.access_ip
  public_sn_count = 2
  private_sn_count = 3
  max_subnets = 20
  public_cidrs = [for   i in range(2,255,2) : cidrsubnet(local.vpc_cidr,8,i)]
  private_cidrs = [for   i in range(2,255,2) : cidrsubnet(local.vpc_cidr,8,i)]
  db_subnet_group = true
  }
    
module "database"{
  source = "./database"
  db_storage = 10
  db_engine_version = "5.7.22"
  db_instance_class = "db.t2.micro"
  dbname = var.dbname
  dbuser = "var.dbuser
  db_password = var.dbpassword
  db_identifier = "huy_db"
  skip_db_snapshot = true
  db_subnet_group_name = ""
  vpc_security_group_ids = []
}
  
module "loadbalancing"{
  source = "./loadbalancing"
  public_sg = module.networking.public_sg
  public_subnets = module.networking.public_subnets
}

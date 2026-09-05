# ============================================
# ROOT MAIN - Calls the infra-app module
# ============================================

module "infra-app" {
  source = "./modules/infra-app"
  
  # Environment
  env = var.env
  aws_region = var.aws_region
  
  # ==========================================
  # VPC CONFIGURATION
  # ==========================================
  vpc_cidr_block = var.vpc_cidr_block
  
  # ==========================================
  # AMI SELECTION (Manual)
  # ==========================================
  web_ami_id     = var.web_ami_id
  app_ami_id     = var.app_ami_id
  bastion_ami_id = var.bastion_ami_id
  
  # ==========================================
  # INSTANCE TYPES (Manual)
  # ==========================================
  web_instance_type     = var.web_instance_type
  app_instance_type     = var.app_instance_type
  bastion_instance_type = var.bastion_instance_type
  
  # ==========================================
  # EC2 CONFIGURATION
  # ==========================================
  ec2_root_vol_size = var.ec2_root_vol_size
  assign_public_ip  = var.assign_public_ip
  
  # ==========================================
  # KEY PAIR
  # ==========================================
  key_name        = var.key_name
  public_key_path = var.public_key_path
  
  # ==========================================
  # DATABASE
  # ==========================================
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  db_storage_size   = var.db_storage_size
  db_engine_version = var.db_engine_version
  
  # ==========================================
  # TAGS
  # ==========================================
  tags = var.tags
}
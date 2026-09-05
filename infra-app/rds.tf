# ============================================
# DATABASE SUBNET GROUP
# ============================================

resource "aws_db_subnet_group" "db-subnet" {
  name        = "${var.env}-db-subnet"
  description = "Subnet group for RDS"
  subnet_ids  = [
    aws_subnet.db_snet-01-1a.id,  # ← Using your DB subnet
    aws_subnet.db_snet-02-1b.id   # ← Using your DB subnet
  ]
  
  tags = {
    Name = "${var.env}-db-subnet"
    Env  = var.env
  }
}

# ============================================
# RDS POSTGRESQL DATABASE
# ============================================

resource "aws_db_instance" "db" {
  identifier = "${var.env}-db"
  
  # Engine Configuration
  engine         = "postgres"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  
  # Database Credentials
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  # Storage
  allocated_storage = var.db_storage_size
  storage_type      = "gp3"
  storage_encrypted = true
  
  # Network - Using your DB subnets via the subnet group
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db-subnet.name  # ← References the subnet group
  
  # Backups
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Sun:04:00-Sun:05:00"
  
  # High Availability (disabled for dev)
  multi_az = false
  
  # Deletion Protection
  deletion_protection = false
  
  # Final Snapshot
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.env}-db-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  
  # Tags
  tags = {
    Name        = "${var.env}-postgres-db"
    Environment = var.env
    Tier        = "DB"
    Engine      = "PostgreSQL"
    ManagedBy   = "Terraform"
  }
}
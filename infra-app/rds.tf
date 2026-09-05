# ============================================
# RDS POSTGRESQL INSTANCE
# ============================================

resource "aws_db_instance" "db" {
  identifier = "${var.env}-db"
  
  # PostgreSQL Configuration
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = var.db_instance_class
  
  # Database Credentials
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  # Storage
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true
  
  # Network
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
  
  # Backups (7 days retention)
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Sun:04:00-Sun:05:00"
  
  # Multi-AZ (disabled for simplicity)
  multi_az = false
  
  # Keep final snapshot
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.env}-db-final-snapshot"
  
  # Tags
  tags = {
    Name = "${var.env}-postgres-db"
    Env  = var.env
    Tier = "DB"
  }
}
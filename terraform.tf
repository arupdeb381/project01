# Option 1: Local backend (for testing)
# No configuration needed - terraform.tfstate will be created locally

# Option 2: S3 Remote State (Production)
terraform {
  backend "s3" {
    bucket         = "projects381"
    key            = "3tier-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
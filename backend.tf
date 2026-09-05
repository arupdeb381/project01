terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.62.0"
    }
  }
  backend "s3" {
  bucket = "my-terraform-state-bucket-3810"
  key    = "terraform-module-app.tfstate"
  region = "us-east-1"
  use_lockfile = true
  }
}

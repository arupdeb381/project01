resource "aws_s3_bucket" "terraform-state" {
  bucket = "${var.env}-${var.bucket_name}"

  tags = {
    Name        = "${var.env}-${var.bucket_name}"
    Environment = var.env
  }
}

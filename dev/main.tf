module "s3_static_website" {
  source = "../modules/aws/s3"

  bucket_name = var.bucket_name

  tags = {
    Project     = "Practica Final"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Bootcamp    = "Keepcoding AWS"
  }
}

resource "aws_s3_object" "index" {
  bucket       = module.s3_static_website.bucket_id
  key          = "index.html"
  source       = "${path.module}/website/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = module.s3_static_website.bucket_id
  key          = "error.html"
  source       = "${path.module}/website/error.html"
  content_type = "text/html"
}

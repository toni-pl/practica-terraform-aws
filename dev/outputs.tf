output "website_endpoint" {
  description = "Static website endpoint URL"
  value       = "http://${module.s3_static_website.website_endpoint}"
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3_static_website.bucket_id
}

output "bucket_region" {
  description = "The region where the bucket is deployed"
  value       = module.s3_static_website.bucket_region
}

output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_region" {
  description = "The region of the bucket"
  value       = aws_s3_bucket.this.region
}

output "website_endpoint" {
  description = "The static website endpoint"
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
}

output "domain_name" {
  description = "The domain name of the S3 bucket"
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
}

output "id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.bucket.id
}

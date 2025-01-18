output "function_url" {
  description = "The URL of the Lambda function"
  value       = aws_lambda_function_url.latest.function_url
}
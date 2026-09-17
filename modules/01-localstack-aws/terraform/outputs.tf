output "bucket_name" {
  description = "The (public) S3 bucket to investigate."
  value       = aws_s3_bucket.data.bucket
}

output "iam_user" {
  description = "The over-privileged IAM user."
  value       = aws_iam_user.app.name
}

output "security_group" {
  description = "The internet-open security group id."
  value       = aws_security_group.open.id
}

output "secret_name" {
  description = "The Secrets Manager secret holding a plaintext password."
  value       = aws_secretsmanager_secret.db.name
}

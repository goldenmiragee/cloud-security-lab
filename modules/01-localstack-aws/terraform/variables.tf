variable "region" {
  description = "AWS region (LocalStack ignores this but the provider needs it)."
  type        = string
  default     = "us-east-1"
}

variable "suffix" {
  description = "Suffix to keep the S3 bucket name unique."
  type        = string
  default     = "lab"
}

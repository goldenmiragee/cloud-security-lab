# ============================================================================
#  SECURE counter-example — how the same resources should look.
#  Scan this too (`checkov -f secure-example.tf`) and compare the results with
#  vulnerable/main.tf. This is the "after" to the vulnerable "before".
# ============================================================================
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "private_data" {
  bucket = "my-secure-private-bucket"
}

resource "aws_s3_bucket_public_access_block" "private_data" {
  bucket                  = aws_s3_bucket.private_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "private_data" {
  bucket = aws_s3_bucket.private_data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "private_data" {
  bucket = aws_s3_bucket.private_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_security_group" "restricted" {
  name        = "restricted"
  description = "SSH from the corporate VPN only"

  ingress {
    description = "SSH from VPN"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    description = "HTTPS out"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "data" {
  availability_zone = "us-east-1a"
  size              = 20
  encrypted         = true
}

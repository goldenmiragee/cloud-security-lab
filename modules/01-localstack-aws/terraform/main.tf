# ============================================================================
#  INTENTIONALLY INSECURE  — for learning only, deployed to LocalStack (free).
#  Each resource below models a real, common cloud misconfiguration. Your job:
#  find them (see ../challenges.md) and fix them (see ../remediation.md).
# ============================================================================

# --- MISCONFIG 1: public S3 bucket, no encryption, holding "sensitive" data ---
resource "aws_s3_bucket" "data" {
  bucket = "corp-sensitive-data-${var.suffix}"
  tags   = { Environment = "prod", Classification = "confidential" }
}

# public-access block fully DISABLED (should be all true)
resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# bucket policy that allows ANYONE to read every object
resource "aws_s3_bucket_policy" "data_public" {
  bucket = aws_s3_bucket.data.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject"]
      Resource  = "${aws_s3_bucket.data.arn}/*"
    }]
  })
}

# sample object with fake PII (so the exposure is tangible)
resource "aws_s3_object" "pii" {
  bucket  = aws_s3_bucket.data.id
  key     = "exports/customers.csv"
  content = "name,email,ssn,card\nJohn Doe,john@example.com,123-45-6789,4111111111111111\n"
}

# --- MISCONFIG 2: over-permissive IAM policy (wildcard action AND resource) ---
resource "aws_iam_policy" "app_star" {
  name        = "app-service-policy"
  description = "App service permissions"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

resource "aws_iam_user" "app" {
  name = "app-service"
}

resource "aws_iam_user_policy_attachment" "app_admin" {
  user       = aws_iam_user.app.name
  policy_arn = aws_iam_policy.app_star.arn
}

# --- MISCONFIG 3: security group open to the world on admin ports ------------
resource "aws_security_group" "open" {
  name        = "app-open-sg"
  description = "App SG (intentionally open to the internet)"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP from anywhere"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- MISCONFIG 4: secret stored in plaintext (and hardcoded in the IaC) ------
resource "aws_secretsmanager_secret" "db" {
  name = "prod/db/password"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = "SuperSecret123!" # hardcoded plaintext credential — never do this
}

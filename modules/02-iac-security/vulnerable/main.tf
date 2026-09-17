# ============================================================================
#  INTENTIONALLY INSECURE Terraform — for STATIC SCANNING practice only.
#  Do NOT `apply` this to a real account. It exists so Checkov / tfsec / Trivy
#  have plenty to find. Compare against ../secure-example.tf after you scan.
# ============================================================================
provider "aws" {
  region = "us-east-1"
}

# --- S3: public, unencrypted, unversioned, unlogged --------------------------
resource "aws_s3_bucket" "public_data" {
  bucket = "my-insecure-public-bucket"
  acl    = "public-read" # CKV: public ACL
}

resource "aws_s3_bucket_public_access_block" "public_data" {
  bucket                  = aws_s3_bucket.public_data.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# --- Security group: SSH + RDP + all-ports open to the internet --------------
resource "aws_security_group" "wide_open" {
  name        = "wide-open"
  description = "Open to the world"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "RDP"
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

# --- EC2 instance: unencrypted root volume, no IMDSv2, public IP -------------
resource "aws_instance" "web" {
  ami                         = "ami-12345678"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.wide_open.id]

  root_block_device {
    encrypted = false # CKV: unencrypted volume
  }
  # no metadata_options -> IMDSv2 not enforced (SSRF risk)
}

# --- EBS volume: unencrypted -------------------------------------------------
resource "aws_ebs_volume" "data" {
  availability_zone = "us-east-1a"
  size              = 20
  encrypted         = false
}

# --- RDS: public, unencrypted, no backups, hardcoded password ----------------
resource "aws_db_instance" "db" {
  allocated_storage   = 20
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "Password123!" # CKV: hardcoded secret
  publicly_accessible = true
  storage_encrypted   = false
  skip_final_snapshot = true
  backup_retention_period = 0
}

# --- IAM: wildcard admin policy ---------------------------------------------
resource "aws_iam_policy" "admin" {
  name = "too-much"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Action = "*", Resource = "*" }]
  })
}

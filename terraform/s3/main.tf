resource "aws_s3_bucket" "showcase" {
  bucket = "mtfb2"

  # Set Access Control List (ACL) for S3 bucket
  # to List, Read, Write for Bucket owner only
  acl = "private"

  # Enable versioning in case we need to recover previous versions of the S3 object
  versioning {
    enabled = true
  }

  # Encrypt the S3 objects using the default `aws/s3` AWS KMS master key
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
  # In production, to prevent accidental destruction these values would be
  # Use code below for production
  # force_destroy = false
  # lifecycle {
  #   prevent_destroy = true
  # }
  # Use this code for dev
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "AuttyResumeBucket"
  }
}

# Block all public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "showcase" {
  bucket = aws_s3_bucket.showcase.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## Only allow Transport Layer Security (TLS) access to the S3 bucket
resource "aws_s3_bucket_policy" "showcase" {
  bucket = aws_s3_bucket.showcase.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Sid       = "AllowTLSRequestsOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = ["s3:*"]
        Resource  = [aws_s3_bucket.showcase.arn, "${aws_s3_bucket.showcase.arn}/*"]
        Condition = {
          Bool = { "aws:SecureTransport" : false }
        }
      }
    ]
  })
}

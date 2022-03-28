resource "aws_s3_bucket" "showcase" {
  bucket = "mtfb1"

  tags = {
    Name        = "AuttyResumeBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "showcase" {
  bucket = aws_s3_bucket.showcase.id
  acl    = "private"
}

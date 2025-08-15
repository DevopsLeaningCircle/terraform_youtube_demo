resource "aws_s3_bucket" "website" {
  
  bucket = "${var.bucket_name}-${terraform.workspace}"
  force_destroy = true

  tags = {
    Name = "${var.bucket_name}-${terraform.workspace}"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.website.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "PublicReadGetObject"
                Effect = "Allow"
                Principal = "*"
                Action = ["s3:GetObject"]
                Resource = "${aws_s3_bucket.website.arn}/*"
            }
        ]
    })

}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website.bucket
  key = "index.html"
  source = "builds/index.html"
  etag = filemd5("builds/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website.bucket
  key = "error.html"
  source = "builds/error.html"
  etag = filemd5("builds/error.html")
  content_type = "text/html"
}
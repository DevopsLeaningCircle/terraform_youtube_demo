terraform { 
  cloud { 
    
    organization = "terraform-cloud-demo-by-naren-12345" 

    workspaces { 
      name = "devops" 
    } 
  } 
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 6
}

resource "aws_s3_bucket" "website" {
  
  bucket = "${var.bucket_name}-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name = "${var.bucket_name}-${random_id.suffix.hex}"
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
  key = var.index_document
  source = "builds/${var.index_document}"
  etag = filemd5("builds/${var.index_document}")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website.bucket
  key = var.error_document
  source = "builds/${var.error_document}"
  etag = filemd5("builds/${var.error_document}")
  content_type = "text/html"
}
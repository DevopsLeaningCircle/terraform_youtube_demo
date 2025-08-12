provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 6
}

module "s3_static_website" {
  source = "../../modules/s3_static_website"
  bucket_name = "nchejara-static-website-${random_id.suffix.hex}"
  index_document = "index.html"
  error_document = "error.html"
}

resource "aws_s3_object" "index_html" {
  bucket = module.s3_static_website.bucket_name
  key = "index.html"
  source = "builds/index.html"
  etag = filemd5("builds/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket = module.s3_static_website.bucket_name
  key = "error.html"
  source = "builds/error.html"
  etag = filemd5("builds/error.html")
  content_type = "text/html"
}
# Deploy Static Webside on S3



**Note:** Terraform wont't upload files - either use AWS CLI or extra upload resource from terraform.

### AWS CLI commands

    aws s3 sync ./builds s3://my-static-site-example-123


### Using Terraform resource

    # Upload source to s3
    resource "aws_s3_object" "index_html" {
        bucket = aws_s3_bucket.website.id
        key = "index.html"
        source = "builds/index.html"
        etag = filemd5("builds/index.html")
        content_type = "text/html"
    }

    resource "aws_s3_object" "error_html" {
        bucket = aws_s3_bucket.website.id
        key = "error.html"
        source = "builds/error.html"
        etag = filemd5("builds/error.html")
        content_type = "text/html"
    }

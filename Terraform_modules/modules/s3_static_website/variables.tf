variable "bucket_name" {
    type = string
    description = "Name of the S3 bucket!"
}

variable "index_document" {
  type = string
  description = "Name of the index page"
  default = "index.html"
}

variable "error_document" {
  type = string
  description = "Name of the error page"
  default = "error.html"
}
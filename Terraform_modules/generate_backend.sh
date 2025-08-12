#!/bin/bash

set -e

# Validate input
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <bucket-name> <aws-region>"
  echo "Example: sh ./generate_backend.sh devopslearningcircle-terraform-statefile us-east-1"
  exit 1
fi
c

S3_BUCKET="$1"
REGION="$2"
LOCK=true

for dir in modulesTest/*/; do
  MOD_NAME=$(basename "$dir")
  BACKEND_FILE="${dir}backend.tf"

  cat > "$BACKEND_FILE" <<EOF
terraform {
  backend "s3" {
    bucket         = "${S3_BUCKET}"
    key            = "modulesTest/${MOD_NAME}/terraform.tfstate"
    region         = "${REGION}"
    use_lockfile = $LOCK
  }
}
EOF

  echo "✅ Created $BACKEND_FILE"
done
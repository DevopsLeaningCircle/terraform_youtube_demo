# Terraform State File

The Terraform state file (terraform.tfstate) is a JSON file where Terraform keeps a record of the real-world infrastructure it manages.


There are 2 types of state file in terraform

1. Local State file
2. Remore State file

### Local State File

    - Store in your local machine (store in the current directory by default)

    - Good for single user, Collaboration leads conflicts

    - No In-build locaking, multiple applies can cause file corruption.

    - Risk of losing the file or  exposing secrets if machine is compromised.

    - Execution performance observed very fast for the single user

### Remote State file

    - Store on the remote location such as S3, Azure blob, GCS, Terraform Cloud, etc.

    - Great for team collaboration as its a central shared location.

    - Support locking via DynamoDB in AWS.

    - Storage can be encrypted
    - Performace will be slightly slower due to the network calls.


### Use S3 + DynamoDB
S3 is used to store State file and DynamoDB use for locking the State file when a user executing **Terraform apply** command.

#### Create DynamoDB in AWS

You must manually create it before running **terraform init**

```
    aws dynamodb create-table --table-name terraform-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST

```

#### Terraform Backend Config

```
    terraform {
        backend "s3" {
            bucket         = "devopslearningcircle-terraform-statefile"
            key            = "dev/terraform.tfstate"
            region         = "us-east-1"
            dynamodb_table = "terraform-locks"
            encrypt        = true
        }
    }

```

#### Use S3 + native state locking

Starting with Terraform 1.10, the S3 backend added support for native state locking—previously, remote state locking required a DynamoDB table. Enabling this feature is done simply by setting:

```
    use_lockfile = true
```

This configures Terraform to use S3-native locking instead of DynamoDB. It works by leveraging S3's conditional write capability: Terraform attempts to create a lock file (with the .tflock extension) next to your state file in S3. If no such file exists, S3 creates it—otherwise, it returns an error, preventing concurrent operations.

#### S3 Native locking bring following benefits:

    - **Simplified Setup** - No need to provision or manage a DynamoDB table
    - **Lower Cost**: Eliminates DynamoDB read/write charges.
    - **Easier Migration**: Supports both S3 and SynamoDB locks during transition; You can remove the DynamoDB_table configuration later.

    ```

        terraform {
            backend "s3" {
                bucket         = "devopslearningcircle-terraform-statefile"
                key            = "dev/terraform.tfstate"
                region         = "us-east-1"
                encrypt        = true
                use_lockfile   = true
            }
        }

    ```
# Terraform Environment Variables

In Terraform, environment variables are a way to configure settings and pass sensitive values without hardcoding them into .tf files or command-line arguments.

They are especially useful for:

1. Supplying credentials (AWS, Azure, GCP, etc.)
2. Overriding Terraform settings (CLI config)
3. Passing input variables securely


## 1. Types of Environment Variables in Terraform

### 1.1 Terraform-specific environment variables

These control how Terraform itself behaves.
Format: TF_*

| Variable              | Purpose                                                         |
| --------------------- | --------------------------------------------------------------- |
| `TF_LOG`              | Sets logging level (`TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`). |
| `TF_LOG_PATH`         | Write logs to a file instead of stdout.                         |
| `TF_INPUT`            | `true`/`false` — disable prompts for input.                     |
| `TF_IN_AUTOMATION`    | `true` — changes output format for CI/CD.                       |
| `TF_WORKSPACE`        | Selects the workspace without `terraform workspace select`.     |
| `TF_CLI_ARGS`         | Extra arguments passed to all Terraform commands.               |
| `TF_DATA_DIR`         | Change `.terraform` working directory path.                     |
| `TF_PLUGIN_CACHE_DIR` | Cache directory for provider plugins.                           |


### 1.2 Provider-specific environment variables
These are used for authentication/configuration with a specific provider.

**Example – AWS:**

    export AWS_ACCESS_KEY_ID="AKIA..."
    export AWS_SECRET_ACCESS_KEY="your-secret"
    export AWS_DEFAULT_REGION="us-east-1"

**Example – Azure:**

    export ARM_CLIENT_ID="app-id"
    export ARM_CLIENT_SECRET="password"
    export ARM_TENANT_ID="tenant-id"
    export ARM_SUBSCRIPTION_ID="subscription-id"

### 1.3 Input variable environment variables
You can set Terraform variable values without passing -var flags.

**Format:**

    TF_VAR_<variable_name>

**Example – variable in variables.tf**

    variable "instance_type" {
    type    = string
    default = "t2.micro"
    }

**Set it with environment variable:**

    export TF_VAR_instance_type="t3.medium"
    terraform apply

Terraform will automatically use this value.


## 2. How to Set Environment Variables

**Linux / macOS**

    export TF_LOG=DEBUG
    export TF_VAR_region="us-west-2"

**Windows PowerShell** 

    $env:TF_LOG = "DEBUG"
    $env:TF_VAR_region = "us-west-2"

## 3. Priority (Precedence)

When setting variables in Terraform, the order of precedence is:

- CLI flags (terraform apply -var="x=1") – highest priority
- TF_VAR_ environment variables
- .tfvars or .auto.tfvars files
- Default values in variables.tf – lowest priority

## 4. Example: Using Environment Variables in CI/CD

**GitHub Actions example:**

    env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        TF_VAR_instance_type: t3.large

    steps:
    - name: Terraform Init
      run: terraform init

    - name: Terraform Apply
      run: terraform apply -auto-approve

** Jenkins Pipeline**

    pipeline {
        agent any

        environment {
            AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
            TF_VAR_region         = 'us-east-1'  // Terraform input variable
            TF_LOG                = 'INFO'       // Terraform log level
        }

        stages {
            stage('Checkout Code') {
                steps {
                    git branch: 'master', url: '<Github Repository URL>'
                }
            }

            stage('Terraform Init') {
                steps {
                    sh '''
                        terraform init
                    '''
                }
            }

            stage('Terraform Plan') {
                steps {
                    sh '''
                        terraform plan
                    '''
                }
            }

            stage('Terraform Apply') {
                steps {
                    sh '''
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }

# Variable Precedence in Terraform

In Terraform, variable precedence determines which value gets used when a variable is defined in multiple places.

Here’s the order of precedence **(highest → lowest)**:

### 1. Command-line flag -var

```
   
    terraform apply -var="region=us-east-1"

```

This overrides everything else.

### 2. Command-line variable file -var-file

```

    terraform apply -var-file="custom.tfvars"

```

### 3. Environment variables

Variables prefixed with TF_VAR_.

Example:
```

    export TF_VAR_region=us-east-2
    terraform apply

```

### 4. terraform.tfvars file (auto-loaded if present).

### 5. *.auto.tfvars or *.auto.tfvars.json files (auto-loaded in lexical order).

### 6. Explicit default values in variable blocks
```
    variable "region" {
        type    = string
        default = "us-west-1"
    }
```

**Key Rule**
👉 The highest-precedence source wins if the same variable is defined in multiple places.
# Workspace Demo

In this Demo, we are going to deploy a static website for QA and Dev using terraform workspace feature which shared your terraform scripts.


## How to Do?

1. Create a new workspace called: qa

    terrafrom init
    terrafrom workspace new qa
    terraform workspace select qa

2. Provisioning AWS resources using terrafrom

    terraform init
    terraform plan
    terraform apply --auto-approve

3. Validate the resource provisioned successfully!

4. Create a new workspace called: dev

    terrafrom init
    terrafrom workspace new dev
    terraform workspace select dev

5. Provisioning AWS resources using terrafrom

    terraform init
    terraform plan
    terraform apply --auto-approve

6. Validate the resource
7. Cleanup
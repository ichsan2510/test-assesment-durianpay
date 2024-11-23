# test-assesment-durianpay

## Tech

Terraform are mainly used to manage cloud services and codifies cloud APIs into declarative configuration files.
We also utilize terragrunt as a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.


[Terraform](https://www.terraform.io/)
[Terragrunt](https://terragrunt.gruntwork.io/)

## Run from local

Since we mainly use Terragrunt, to apply our Terraform code, you could follow steps below.
1. RUN `export AWS_PROFILE="your profile aws"` 

2. Navigate to Terraform folder you want to apply.

3. Run `terragrunt init` to get Terraform modules and dependencies.

4. Run `terragrunt workspace select <workspace>` to select workspace. Workspace names we mostly use are `dev`, `stg`, and `prd`, if you have many diffrent env you can use this method

5. Run `terragrunt plan` to see what resources that will be created, modified, or destroyed.

6. Run `terragrunt apply` to apply Terraform configuration.


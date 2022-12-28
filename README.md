# terraform-aws-baseline

## Goal

-   Create infrastructure to host terraform state such that other repositories can be deployed to AWS without having to store terraform state on my local machine
    -   S3 Bucket
    -   Dynamo DB table
-   Not a module to start with but can be made into one once initial setup is complete
-   Will only be deployed a single AWS account for now so no environments folder is necessary

## Helpful resources

- https://technology.doximity.com/articles/terraform-s3-backend-best-practices

## Other things to figure out

- AWS SSO and temporary credentials


## AWS SSO and temporary credentials

- Enable AWS Organisations on the AWS account
- Navigate to IAM Identity Center (replacement for AWS SSO)
- Save AWS SSO Start URL
- Go to Users and create a new user
- Create Administrators Group and add new user to this group
- Create new permission set using AWSAdministratorAccess policy a

# terraform-aws-baseline

Creating this as reference for myself and as a quick getting started repo should I need to quickly setup an AWS account.

## Setting up terraform with AWS

-   `stateSetup.tf` contains the infrastructure needed to host your terraform state. It is just an s3 bucket to hold the state itself and a DynamoDB table to hold locking information that terraform uses to prevent race conditions that could happen if you tried to change the same infrastructure at the same time from different terraform deplyoments.
-   Firstly comment out the terraform block at the top of this file.
-   Run `terraform init`
-   Run `terraform apply --auto-approve`
-   Then uncomment the terraform block at the top of this file. Go to S3 an copy the s3 bucket name of the created bucket(should begin with name terraform-state) and put it in the bucket key of this block. You now have a terraform backend. We then need to run the above commands again to inpu
-   Run `terraform init` again. You will be asked "Do you want to copy the existing state to the new backend?". Type yes to this. This will copy the terraform state that is stored localy in `terraform.tfstate` and pop it in your new s3 bucket.
-   Your terraform state is now hosted by AWS rather than stored on your local system. Just use the terraform backend block found in `stateSetup.tfstate` in any other terraform you write.

## Helpful resources

-   https://technology.doximity.com/articles/terraform-s3-backend-best-practices

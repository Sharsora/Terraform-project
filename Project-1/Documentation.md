
### Local setup
- install Terraform on your platform
- install AWS-CLI to use the aws functionally from your terminal

### Now in AWS Console

- Create USER
- actually, we should follow the Principle of least privilege but we need to use many services to here you can give AdministratorAccess.
- Create Acess key
- Configure AWS-CLI

  Store state files on remote location
- create an s3 bucket to save the state file on a remote location
- create bucket name learning-terraform
- Also enable Bucket versioning to allow for state recovery in the case of accidental deletions and human error.

- state-locking so that we can keep tfstate file consistent while working on a collaborative project

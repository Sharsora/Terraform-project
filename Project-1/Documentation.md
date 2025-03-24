
### Local setup
- Install Terraform on your platform
- Install AWS-CLI to use the aws functionally from your terminal

### Now in AWS Console

- Create USER
- Actually, we should follow the Principle of least privilege but we need to use many services to here you can give AdministratorAccess.
- Create Acess key
- Configure AWS-CLI

  Store state files on remote location
- Create an s3 bucket to save the state file on a remote location
- Create bucket name learning-terraform
- Also enable Bucket versioning to allow for state recovery in the case of accidental deletions and human error.

- Check state-locking so that we can keep tfstate file consistent while working on a collaborative project

- Now go to the dynamoDB service dashboard and click on create table button. Give your table name whatever you want but in Partition Key give the name LockID (NOTE: it is case sensitive) and type as String becoz then only dynamoDB will be able to lock the file and release the file. and then click on create table button.

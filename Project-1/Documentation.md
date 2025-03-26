
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

- Create terraform.tfvars file, you can name anything just needs to end with .tfvars or .auto.tfvars significant of this file is the variables that you have declares in variables.tf, you can initialise variables with the value over here.

- Backend.tf
- storage location inside AWS from where you are accessing tfstate file. All the information about your infrastructure resources will be store inside this file when you run terraform apply. so that when you next time run terraform apply, it will just compare your desire state with actual state. for exaple let say you have two EC2 instance already created, and you want to create one more, so kust add one more block inside your terraform to create another server, so it will just compare that with tfstate file. so we already have two servers created and we need to create one more. instead of creating 3 servers. that is the use of tfstate file.
- When we dont use backend it will just store the tfstate file locally in your server and it will have some confidential data it will have details of your credentials. Hence it is best practice to use backend to store tfstate file so that whenever you run terraform command, it will access from S3 bucket.
- the reasone why we not use variables in this file because backend configuration does not support variables so that is why we have hardcoded here.

- why we need DynamoDB table?
- when you have terraform configuration you have stored your tfstate file remotely in S3 backend, now there will be multiple user accessing those configuration at the same time it will acquire something called as as lock to then configuration. To avoid that locking situation you create dynamoDB table.
- Now go to the dynamoDB service dashboard on AWS console and click on create table button. Give your table name whatever you want but in Partition Key give the name LockID (NOTE: it is case sensitive) only then it will be use in the remote backend and type as String becoz then only dynamoDB will be able to lock the file and release the file. and then click on create table button.


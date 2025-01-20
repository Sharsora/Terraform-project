### Deploying Secure EC2 Instances with a Shared RDS Database
![image](https://github.com/user-attachments/assets/23225f4c-a162-4ca7-8d8c-ac8ea27047ef)

## Introduction to Terraform on AWS
- Terraform is an open-source infrastructure as a code software tool that allows you to define and provision a cloud infrastructure using a high-level configuration language. It supports various cloud providers, including AWS, which we will be using for our project.

- Why Terraform?

- Immutable Infrastructure: Terraform encourages the creation of immutable infrastructure through declarative configuration files. This means your infrastructure can be versioned and treated as you would with application code.
- Idempotency: Terraform ensures that running the same configuration multiple times results in the same state, avoiding manual errors and inconsistencies.
- Scalability: With Terraform, scaling your infrastructure up or down becomes a matter of changing a few lines in your configuration file.

## Setting Up Your AWS Environment with Terraform

- Before diving into the specifics, please make sure you have Terraform and AWS CLI installed and configured on your machine.

## Creating a Terraform Configuration File

- Create a new directory for your project and within it, create a file named main.tf. This file will contain the configuration for your AWS resources.
```sh
provider "aws" {
  region = "us-east-1"
}
```

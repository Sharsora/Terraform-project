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
- This specifies that Terraform should use the AWS provider and sets the region where your resources will be created.

```sh
provider "aws" {
  region     = "us-east-1"
  access_key = "<access_key>"
  secret_key = "<secret_key>"
}
```

## Building the Infrastructure

- Our web application will need a VPC, EC2 instances, and an RDS instance. We will define each of these components in our main.tf file.

### Virtual Private Cloud (VPC)

- A VPC is a virtual network dedicated to your AWS account. It is isolated from other virtual networks in the AWS cloud.

```sh
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "AppVPC"
  }
}
```
### Subnets
- Within the VPC, we create subnets. Each subnet resides in a different availability zone for high availability.

```sh
resource "aws_subnet" "app_subnet_1" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "AppSubnet1"
  }
}

resource "aws_subnet" "app_subnet_2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "AppSubnet2"
  }
}
```

### Security Groups
- Security groups act as a virtual firewall for your instances to control inbound and outbound traffic.

```sh
resource "aws_security_group" "app_sg" {
  name        = "app_security_group"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AppSecurityGroup"
  }
}
```
```sh
resource "aws_security_group" "WebTrafficSG" {
  vpc_id = aws_vpc.AppVPC.id
  name   = "WebTrafficSG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebTrafficSG"
  }
}
```

### network interface

- Create two network interfaces - nw-interface1 and nw-interface2.
- Both of the interfaces should use WebTrafficSG as the security group, while the nw-interface1 should use AppSubnet1 and nw-interface2 use AppSubnet2 respectively.
Note: The names for the interfaces should be their tags.

```sh
resource "aws_network_interface" "nw-interface1" {
  subnet_id = aws_subnet.AppSubnet1.id
  security_groups = [aws_security_group.WebTrafficSG.id]
  tags = {
    Name        = "nw-interface1"
  }  
}

resource "aws_network_interface" "nw-interface2" {
  subnet_id = aws_subnet.AppSubnet2.id
  security_groups = [aws_security_group.WebTrafficSG.id]
  tags = {
    Name        = "nw-interface2"
  }  
}
```

- Attach the network (AppVPC) to any Internet Gateway. Tag this gateway as AppInternetGateway.

- Also, create a route table for the VPC AppVPC. Tag this table as AppRouteTable. Create an associated output for this ID named route_table_ID.

```sh
resource "aws_internet_gateway" "AppIGW" {
  vpc_id = aws_vpc.AppVPC.id

  tags = {
    Name = "AppInternetGateway"
  }
}

resource "aws_route_table" "AppRouteTable" {
  vpc_id = aws_vpc.AppVPC.id
  tags = {
    Name = "AppRouteTable"
  }
}

output "route_table_ID" {
  value = aws_route_table.AppRouteTable.id
}
```
- Create a route in your AWS infrastructure to allow internet access. The route should be associated with the route table named AppRouteTable and should direct traffic to the internet gateway named AppInternetGateway.

- Set the destination CIDR block to 0.0.0.0/0 to allow all outbound traffic.


```sh
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.AppRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.AppIGW.id
}
```

- Associate two subnets, AppSubnet1 and AppSubnet2, with the route table named AppRouteTable to ensure that the subnets use this route table for their traffic routing.

```sh
resource "aws_route_table_association" "AppSubnet1_association" {
  subnet_id      = aws_subnet.AppSubnet1.id
  route_table_id = aws_route_table.AppRouteTable.id
}

resource "aws_route_table_association" "AppSubnet2_association" {
  subnet_id      = aws_subnet.AppSubnet2.id
  route_table_id = aws_route_table.AppRouteTable.id
}
```

- To ensure that our future EC2 instances get assigned a public IP address, create two Elastic IP (EIP) resources and attach to one network interface each - nw-interface1 andnw-interface2.

```sh
resource "aws_eip" "public_ip1" {
  vpc = true
  network_interface = aws_network_interface.nw-interface1.id
}

resource "aws_eip" "public_ip2" {
  vpc = true
  network_interface = aws_network_interface.nw-interface2.id
}
```

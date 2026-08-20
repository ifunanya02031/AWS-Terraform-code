# AWS Three-Tier Dynamic Web Application Deployment

## Overview

This project demonstrates the deployment of a production-style dynamic web application on Amazon Web Services (AWS). The application, built using a NestJS-based grocery store platform, was deployed within a secure, highly available cloud environment utilizing multiple AWS services including Amazon VPC, EC2, RDS, S3, IAM, Secrets Manager, and Application Load Balancer (ALB).

The objective of this project was to design and implement a secure cloud architecture that separates application, database, and management functions while following AWS networking and security best practices.

---

## Architecture

The solution follows a three-tier architecture consisting of:

### Presentation Layer

* Application Load Balancer (ALB)
* Public Subnets
* Internet Gateway (IGW)

### Application Layer

* EC2 Application Server
* EC2 Flyway Migration Server
* Private Subnets
* NAT Gateway

### Data Layer

* Amazon RDS (MySQL)
* AWS Secrets Manager

---

## Technologies Used

| Technology                      | Purpose                                        |
| ------------------------------- | ---------------------------------------------- |
| Amazon VPC                      | Network isolation and segmentation             |
| Public & Private Subnets        | Secure workload placement                      |
| Internet Gateway (IGW)          | Public internet access                         |
| NAT Gateway                     | Outbound internet access for private resources |
| EC2                             | Application hosting and database migration     |
| Application Load Balancer (ALB) | Traffic distribution                           |
| Amazon RDS (MySQL)              | Managed relational database                    |
| Amazon S3                       | Application artifact storage                   |
| IAM Roles                       | Secure service permissions                     |
| AWS Secrets Manager             | Credential management                          |
| Flyway                          | Database schema migrations                     |
| NestJS                          | Dynamic web application framework              |

---

## Project Components

### Virtual Private Cloud (VPC)

A custom VPC was created to provide network isolation and establish the foundation for the application architecture.

The VPC included:

* Public subnets
* Private subnets
* Route tables
* Internet Gateway
* NAT Gateway

This design ensured public-facing resources remained accessible while protecting application and database resources from direct internet exposure.

---

### Public and Private Subnets

The environment was segmented into public and private subnets.

#### Public Subnets

Hosted:

* Application Load Balancer (ALB)
* NAT Gateway

The public subnets maintained internet connectivity through the Internet Gateway.

#### Private Subnets

Hosted:

* Application EC2 Instance
* Flyway Migration EC2 Instance
* Amazon RDS Database

Resources within private subnets were not directly accessible from the internet.

Outbound connectivity was provided through the NAT Gateway.

---

### Application Load Balancer (ALB)

An Application Load Balancer was deployed within public subnets to receive client traffic and route requests to the application server.

Responsibilities included:

* HTTP traffic handling
* HTTPS traffic handling
* Traffic distribution
* Application endpoint exposure

The ALB served as the public entry point into the environment.

---

### EC2 Application Server

A dedicated EC2 instance was deployed within a private subnet to host the NestJS grocery store application.

Responsibilities included:

* Hosting application code
* Processing user requests
* Communicating with RDS
* Retrieving required resources from AWS services

The application server was intentionally isolated from direct internet access.

---

### EC2 Flyway Migration Server

A separate EC2 instance was deployed to manage database schema migrations using Flyway.

Responsibilities included:

* Executing migration scripts
* Updating database structure
* Managing schema changes
* Referencing application artifacts stored within S3

This separation of responsibilities aligns with enterprise deployment practices.

---

### Amazon RDS (MySQL)

Amazon RDS served as the backend relational database for the application.

The database stored dynamic application data including:

* User information
* Product data
* Application transactions
* Inventory records

Database access was restricted through dedicated security group controls.

---

### Amazon S3

An S3 bucket was used to store application artifacts and deployment resources.

The Flyway migration server accessed these resources during deployment and database migration activities.

Benefits included:

* Centralized storage
* Durable object storage
* Secure artifact management
* Simplified deployment workflows

---

### IAM Roles

IAM Roles were assigned to EC2 instances to securely access AWS resources without embedding credentials within the application.

Permissions included:

* S3 access
* Secrets Manager access
* Application resource access

This implementation follows AWS security best practices by eliminating hardcoded credentials.

---

### AWS Secrets Manager

Secrets Manager was used to securely store database credentials and sensitive configuration data.

Benefits included:

* Credential protection
* Secure database authentication
* Centralized secret management
* Reduced credential exposure

The application and migration servers retrieved credentials dynamically when required.

---

## Security Architecture

Security was enforced through multiple AWS Security Groups.

### alb-sg

Attached To:

* Application Load Balancer

Allowed:

* HTTP (80)
* HTTPS (443)

Purpose:

* Accept public traffic
* Forward requests to backend resources

---

### eice-sg

Attached To:

* EC2 Instance Connect Endpoint (EICE)

Purpose:

* Administrative access
* Secure SSH connectivity
* Server maintenance and updates

This eliminated the need for publicly accessible EC2 instances.

---

### rds-sg

Attached To:

* Amazon RDS

Allowed:

* MySQL Traffic (3306)

Restrictions:

* Only trusted resources were permitted database connectivity

Purpose:

* Protect database resources
* Enforce least privilege access

---

### dms-sg

Attached To:

* Flyway Migration Server

Allowed:

* Administrative connectivity
* Migration-related communication

Purpose:

* Database migration activities
* Schema deployment operations

---

## Data Flow

```text
Internet User
      │
      ▼
Application Load Balancer
      │
      ▼
NestJS Application Server (EC2)
      │
      ▼
AWS Secrets Manager
      │
      ▼
Amazon RDS (MySQL)
```

Database Migration Flow:

```text
Amazon S3
      │
      ▼
Flyway Migration Server (EC2)
      │
      ▼
Amazon RDS (MySQL)
```

---

## Skills Demonstrated

* Amazon Web Services (AWS)
* Cloud Infrastructure Design
* Three-Tier Architecture
* Virtual Private Cloud (VPC)
* Public & Private Subnet Design
* Internet Gateway Configuration
* NAT Gateway Configuration
* Application Load Balancer (ALB)
* Amazon EC2
* Amazon RDS
* Amazon S3
* AWS IAM Roles
* AWS Secrets Manager
* Security Group Design
* Infrastructure Security
* Database Migration Management
* Flyway
* Cloud Networking
* Least Privilege Access
* Secure Application Deployment

---

## Learning Outcomes

By completing this project, I gained hands-on experience designing and deploying a secure cloud-native application architecture on AWS. The project reinforced core cloud engineering concepts including network segmentation, secure resource access, database management, secrets management, IAM role delegation, and application deployment within private environments. Additionally, implementing Flyway migrations and integrating multiple AWS services provided practical experience with enterprise deployment patterns commonly used in production cloud environments.

# Host Dynamic Web Application on AWS ECS

## Overview

This project demonstrates the deployment of a production-style dynamic web application on Amazon Web Services (AWS) using Amazon Elastic Container Service (ECS) and Docker containers. Unlike traditional EC2-based deployments where applications run directly on virtual servers, this architecture packages the application into a Docker image, stores the image in Amazon Elastic Container Registry (ECR), and deploys the application as containers managed by ECS.

The solution utilizes modern cloud-native deployment practices, including containerization, orchestration, load balancing, secret management, database integration, logging, and infrastructure automation.

---

# Architecture Overview

```text
Internet
    │
    ▼
Application Load Balancer (ALB)
    │
    ▼
Target Group (IP Targets)
    │
    ▼
ECS Service
    │
    ▼
ECS Tasks (Containers)
    │
    ▼
Docker Image (ECR)
    │
    ▼
Amazon RDS MySQL
```

---

# Key Concepts

## What is Docker?

Docker is a containerization platform that packages an application along with all required dependencies, libraries, runtime configurations, and operating system components into a single portable unit called a container.

Benefits:

* Consistent deployments across environments
* Lightweight compared to virtual machines
* Rapid deployment and scaling
* Eliminates "works on my machine" issues
* Simplified application packaging

---

## Dockerfile

A Dockerfile is a blueprint used to build a Docker image.

Think of a Dockerfile as:

> A deployment script that configures everything required to run an application.

The Dockerfile defines:

* Base operating system
* Server dependencies
* Runtime requirements
* Application code location
* Environment configuration
* Startup commands

Example responsibilities:

* Install Apache
* Install PHP
* Download application code from GitHub
* Configure database settings
* Start required services

---

## Docker Image

A Docker image is a reusable template created from a Dockerfile.

Think of a Docker image as:

> A packaged and portable version of your application environment.

Characteristics:

* Immutable
* Reusable
* Versioned
* Consistent across deployments

Once built, the image contains:

* Operating system
* Application code
* Dependencies
* Configuration
* Runtime settings

---

## Docker Container

A container is a running instance of a Docker image.

Relationship:

```text
Dockerfile
      ↓
Docker Image
      ↓
Docker Container
```

Multiple containers can be created from a single image.

Every container launched from the same image will behave identically.

---

# Amazon Elastic Container Registry (ECR)

Amazon ECR is a managed container image repository.

Purpose:

* Store Docker images
* Version Docker images
* Secure image access
* Integrate with ECS

Workflow:

```text
Docker Image
      ↓
Push to ECR
      ↓
ECS pulls image from ECR
      ↓
Container launches
```

Think of ECR as:

> GitHub for Docker images.

---

# Amazon Elastic Container Service (ECS)

Amazon ECS is AWS's container orchestration service.

Its responsibility is to:

* Deploy containers
* Manage containers
* Scale containers
* Replace failed containers
* Integrate containers with load balancers

Think of ECS as:

> The manager responsible for running and maintaining your containers.

---

# ECS Core Components

## ECS Cluster

An ECS Cluster is a logical grouping of compute resources where containers run.

Think of it as:

> The environment that hosts your containerized workloads.

Responsibilities:

* Organizes services
* Organizes tasks
* Provides compute capacity
* Hosts container workloads

---

## Task Definition

A Task Definition is a blueprint for containers.

Think of it as:

> The equivalent of an EC2 Launch Template for containers.

It defines:

* Docker image
* CPU allocation
* Memory allocation
* Ports
* Environment variables
* IAM roles
* Logging configuration
* Secrets

Example:

```text
Image: nest:latest
CPU: 1 vCPU
Memory: 3 GB
Port: 80
```

The task definition describes:

> HOW a container should run.

---

## ECS Service

An ECS Service maintains the desired number of running containers.

Think of it as:

> The equivalent of an Auto Scaling Group (ASG) for containers.

Responsibilities:

* Launch tasks
* Monitor tasks
* Replace failed tasks
* Register targets with load balancers
* Scale tasks

Example:

```text
Desired Tasks = 2
```

If one task fails:

```text
ECS automatically launches another.
```

The service ensures:

> Your application remains available.

---

# ECS Launch Types

## ECS with Fargate

Serverless container hosting.

AWS manages:

* Servers
* Operating systems
* Docker runtime
* Capacity management
* Patching

You manage:

* Containers
* Task definitions
* Services

Benefits:

* No infrastructure management
* Simplified deployments
* Automatic scaling

---

## ECS with EC2

Self-managed container hosting.

You manage:

* EC2 instances
* Docker installation
* ECS agents
* Patching
* Capacity

ECS manages:

* Container orchestration

Benefits:

* Greater customization
* Hardware control
* Cost optimization at scale

---

# IAM Roles

## ECS Task Execution Role

Used by ECS itself.

Purpose:

* Pull images from ECR
* Send logs to CloudWatch
* Retrieve secrets

Think of it as:

> Permissions for ECS infrastructure.

---

## ECS Task Role

Used by the application running inside the container.

Purpose:

* Access Secrets Manager
* Access S3
* Access CloudWatch APIs
* Access DynamoDB (if needed)

Think of it as:

> Permissions for the application.

---

# AWS Secrets Manager

Secrets Manager securely stores sensitive information such as:

* Database passwords
* API keys
* GitHub Personal Access Tokens

Benefits:

* No hardcoded credentials
* Secure retrieval
* Centralized secret management

Example:

```text
Application
     ↓
IAM Role
     ↓
Secrets Manager
     ↓
Retrieve Password
```

---

# Amazon RDS

Amazon Relational Database Service (RDS) stores application data.

Examples:

* Users
* Products
* Orders
* Blog posts
* Application settings

RDS is considered:

> Stateful infrastructure.

Unlike containers, data remains even when applications restart.

---

# Database Migration Containers

Before the application starts, the database schema must exist.

Migration containers use tools such as:

* Flyway

Responsibilities:

* Create tables
* Update schema versions
* Maintain database structure

Example:

```text
SQL Script
      ↓
Flyway
      ↓
Amazon RDS
```

This process ensures the database structure matches application requirements.

---

# Application Load Balancer (ALB)

The Application Load Balancer distributes traffic to healthy containers.

Responsibilities:

* Accept Internet traffic
* Route requests
* Perform health checks
* Remove unhealthy targets

Traffic flow:

```text
Internet
      ↓
ALB
      ↓
Target Group
      ↓
ECS Containers
```

---

# Target Groups

A Target Group defines where traffic should be sent.

For ECS Fargate:

```text
Target Type = IP
```

Why?

Because Fargate tasks receive their own network interfaces and IP addresses.

Unlike EC2-based applications:

```text
Target Type = Instance
```

ECS/Fargate uses:

```text
Target Type = IP
```

---

# Logging with CloudWatch

CloudWatch captures container logs and operational metrics.

Benefits:

* Application troubleshooting
* Error visibility
* Monitoring
* Performance analysis

Typical logs:

* Apache logs
* PHP logs
* Application logs
* Container startup logs

---

# Container Deployment Workflow

## Build

```text
Dockerfile
     ↓
Docker Image
```

## Push

```text
Docker Image
     ↓
Amazon ECR
```

## Define

```text
Task Definition
```

## Deploy

```text
ECS Service
     ↓
ECS Cluster
```

## Run

```text
Containers
```

## Serve

```text
ALB
     ↓
Users
```

---

# Key Takeaways

* Dockerfiles act as deployment scripts for containers.
* Docker images are reusable application templates.
* Containers are running instances of Docker images.
* ECR stores Docker images.
* ECS manages container deployments.
* Task Definitions define how containers run.
* ECS Services keep containers running.
* ECS Clusters host container workloads.
* Secrets Manager securely stores credentials.
* IAM roles control AWS service access.
* RDS provides persistent database storage.
* ALB distributes traffic to healthy containers.
* CloudWatch provides monitoring and logging.

This architecture demonstrates a modern cloud-native deployment pattern using containerized applications on AWS ECS, providing scalability, consistency, security, and operational efficiency.

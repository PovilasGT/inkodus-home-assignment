# EKS and ArgoCD Infrastructure Setup

This repository contains infrastructure for deploying an EKS cluster, ArgoCD, and Argo applications. The structure of the repository is organized as follows:

- **app**: This directory contains the application code and Dockerfile. For this example I've picked up Python microservice based on Flask.
- **terraform**: The Terraform directory is responsible for creating the underlying infrastructure. It uses EKS blueprints to simplify provisioning, which includes creating a VPC, EKS cluster, ECR repository, and deploying ArgoCD as an addon.
- **argo**: The Argo directory contains Argo applications and the application Helm chart.

Ideally, it's a good practice to keep these directories as separate repositories. Additionally, for best practices, consider separating Argo applications into their own repositories.

## Prerequisites

Before getting started, make sure you have the following prerequisites installed:

- `aws-cli`: The AWS Command Line Interface.
- `kubectl`: The Kubernetes command-line tool.

To enable Terraform to provision infrastructure, you'll need to create an S3 bucket and DynamoDB table to store the remote state. Here's an example of how to create these resources using AWS CLI commands:

```bash
aws s3api create-bucket \
	--region "us-east-1" \
	--bucket "hello-app-state-bucket"

aws dynamodb create-table \
	--region "us-east-1" \
	--table-name hello-app-state-lock \
	--attribute-definitions AttributeName=LockID,AttributeType=S \
	--key-schema AttributeName=LockID,KeyType=HASH \
	--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
```
## Setup and Deployment Documentation

## Prerequisites

Before you begin, make sure to set up the following GitHub environment secrets for the workflows to work:

- `AWS_ACCESS_KEY_ID`
- `AWS_REGION`
- `AWS_SECRET_ACCESS_KEY`
- `MY_GITHUB_TOKEN`

These secrets are necessary for securely managing your infrastructure and repositories.

## Repository Connection

After provisioning the infrastructure, you can establish a connection with your Git repository by executing the following command:

```bash
kubectl apply -n argocd -f config/argocd-git-repo.yaml
```
This command creates a repository in ArgoCD for your application. Make sure to update the `password` field in config/argocd-git-repo.yaml with your valid GitHub token. This is a one-time setup operation.

## Application Deployment

Once the repository is connected, ArgoCD can access your Git repository. To deploy your first Argo application, execute the following command:

```bash
kubectl apply -n argocd -f argo/argo-apps/dev/templates/hello-app.yaml
```

This is also a one-time operation. Afterward, ArgoCD will continuously synchronize your desired state in GitHub with the ArgoCD cluster.

## CI/CD Workflows

GitHub Workflows are used to automate CI/CD processes:

- `terraform.yaml`
This workflow is triggered by changes within the terraform directory.
It runs terraform plan on pull requests to assess changes.
Upon merging the pull request, it executes terraform apply to apply the changes to your infrastructure.
- `app-build.yaml`
This workflow is triggered by changes within the app directory.
It builds a Docker image of your application.
It scans the Docker image using Trivy, a GitHub action for image vulnerability scanning.
Finally, it pushes the Docker image to your registry.
These workflows automate infrastructure provisioning, application deployment, and image management, enhancing your development and deployment process.

## Promotion

Currently image update of application needs to be done by updating image tag of our chart and creating PR. After PR is merged argocd will syncronize and will deploy new image from registry to the cluster. Idealy we want to automate this step and introduce perhaps staging environment as well where we can run functional, integration tests before promoting to prod.

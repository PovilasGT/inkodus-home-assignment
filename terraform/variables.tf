variable "region" {
  default = "us-east-1"
  type    = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "hello-vpc"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "hello-eks"
}

variable "repository_name" {
  description = "ECR registry name"
  type        = string
  default     = "hello-app"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "eks_tags" {
  description = "The tags to apply to the EKS cluster"
  type    = map(string)
  default = {
    Name = "Terraform managed"
  }
}

variable "vpc_tags" {
  description = "The tags to apply to the EKS cluster"
  type    = map(string)
  default = {
    Name = "Terraform managed"
  }
}

variable "github_token" {
  description = "Github access token for argocd"
  type        = string
  sensitive   = true
}

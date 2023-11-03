terraform {
  backend "s3" {
    bucket = "hello-app-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "hello-app-state-lock"
  }
}

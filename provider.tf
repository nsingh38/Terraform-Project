provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "nampal-test-bucket"
    key    = "terraform-backend/terraform.tfstate"
    region = "us-west-2"

    dynamodb_table = "terraform-np"
  }
}

terraform {
  required_version = ">=0.12"
  backend "s3" {
    bucket = "aws-bucket-demo"
    key    = "demo.tfstate"
    region = "us-east-1"
  }

}
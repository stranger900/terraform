terraform {
  required_version = ">=0.12"
  backend "s3" {
    bucket = "aws-bucket-demo3"
    key    = "demo3.tfstate"
    region = "us-east-1"
  }

}
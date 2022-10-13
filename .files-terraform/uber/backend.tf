terraform {
  backend "s3" {
    bucket         = "projectuber-bucket"
    key            = "uber_terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "s3-lock"
  }
}
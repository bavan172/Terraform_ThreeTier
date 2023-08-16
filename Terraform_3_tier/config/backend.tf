terraform {
  backend "s3" {
    bucket = "app-tf-st-bckt"
    key    = "app.tfstate"
    region = "us-west-1"
    profile = "terraform"
    # dynamodb_table = "value"
  }
}
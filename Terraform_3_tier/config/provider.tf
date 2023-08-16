

provider "aws" {
  region = var.AWS_REGION
  profile = "terraform"
}

provider "aws" {
  region = "us-east-1"
  alias = "otherregion"
  profile = "terraform"
}
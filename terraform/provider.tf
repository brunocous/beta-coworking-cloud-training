terraform {
  required_version = "> 0.12.0"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "TBA"
  version = ">= 2.6.0"
}
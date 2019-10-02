terraform {
  required_version = "> 0.12.0"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "beta-cowork"
  version = ">= 2.6.0"
}


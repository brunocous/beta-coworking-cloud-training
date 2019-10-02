terraform {
  backend "s3" {
    key = "terraform/datalake/eu-west-1/terraform.tfstate"
  }
}
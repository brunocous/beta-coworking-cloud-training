variable "account-id" {
  description = "ID of AWS account"
}

variable "region" {
  description = "AWS region"
}

variable "airflow-ami-id" {
  description = "ID of the AMI of airflow"
}

variable "datalake-bucket" {
  description = "S3 bucket of datalake"
}

variable "git-repo" {
  description = "URL of student git repo"
}

variable "student-id" {
  description = "Unique ID of student"
}
module "aws-infra" {
  source = "./aws-infra"

  account-id = local.account_id
  region = "eu-west-1"

  student-id = "brunoc"
  git-repo = "https://github.com/brunocous/beta-coworking-cloud-training.git"
  airflow-ami-id = "ami-d834aba1"
  datalake-bucket = "betacowork-data"
}
module "aws-infra" {
  source = "./aws-infra"

  account-id = local.account_id
  region = "eu-west-1"

  student-id = "brunoc"
  git-repo = "https://github.com/brunocous/beta-coworking-cloud-training.git"
  airflow-ami-id = "ami-06358f49b5839867c"
  datalake-bucket = "betacowork-data"

  ec2-key-pair-name = "teacher1"
}
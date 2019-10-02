resource "random_string" "db-password" {
  length = 16
  special = true
  override_special = "/@"
}

resource "aws_db_instance" "airflowdb" {
  instance_class = "db.t2.micro"
  engine = "postgres"
  username = "airflow"
  password = random_string.db-password.result
  allocated_storage = 5
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.AirflowEC2SG.id]
}

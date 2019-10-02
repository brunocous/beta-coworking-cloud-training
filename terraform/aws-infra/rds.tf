resource "random_string" "db-password" {
  length = 16
  special = true
  override_special = "/@£$"
}

resource "aws_db_instance" "airflowdb" {
  instance_class = "db.t2.micro"
  engine = "postgres"
  username = "airflow"
  password = random_string.db-password.result
  allocated_storage = 5
  vpc_security_group_ids = [aws_db_security_group.rds-security-group.id]

}

resource "aws_db_security_group" "rds-security-group" {
  name = "rds-security-group"
  description = "Frontend Access"

  ingress {
    security_group_id = aws_security_group.AirflowEC2SG.id
  }
}

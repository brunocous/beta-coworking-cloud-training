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
  name = "${var.student-id}-rds-security-group"
  description = "Frontend Access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

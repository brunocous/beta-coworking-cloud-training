resource "random_string" "db-password" {
  length = 16
}

resource "aws_db_instance" "airflowdb" {
  instance_class = "db.t2.micro"
  engine = "postgres"
  name = "${var.student-id}-airflowdb"
  username = "airflow"
  password = random_string.db-password.result
  allocated_storage = 5
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.db-security-group.id]
}

resource "aws_security_group" "db-security-group" {
  name        = "postgres-security-group"
  description = "Enable tcp on 5432 from everywhere"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

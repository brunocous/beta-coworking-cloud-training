resource "aws_instance" "airflow-instance" {
  ami           = var.airflow-ami-id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.airflow-instance-profile.name

  tags = {
    Name = "Airflow"
  }

  user_data = data.template_file.start-script-airflow.rendered

  vpc_security_group_ids = [aws_security_group.AirflowEC2SG.id]
}

resource "aws_security_group" "AirflowEC2SG" {
  name        = "AirflowEC2SG"
  description = "Enable HTTP acces via port 80 + SSH access"

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

data template_file "start-script-airflow" {
  template = file("${path.module}/templates/user_data.tpl")
  vars = {
    aws_region = var.region
    datalake_bucket = var.datalake-bucket
    db_password = random_string.db-password.result
    db_endpoint = aws_db_instance.airflowdb.endpoint
    fake_stack_id = random_string.stack-id.result
  }
}

resource "random_string" "stack-id" {
  length = 16
  special = false
}


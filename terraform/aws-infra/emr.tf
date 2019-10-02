resource "aws_security_group" "AirflowEMRMasterSG" {
  name        = "AirflowEMRMasterSG"
  description = "Airflow EMR Master SG"

  ingress {
    from_port   = 8998
    to_port     = 8998
    protocol    = "tcp"
    security_groups = [aws_security_group.AirflowEC2SG.id]
  }
}

resource "aws_security_group" "AirflowEMRSlaveSG" {
  name = "AirflowEMRSlaveSG"
  description = "Airflow EMR Slave SG"
}
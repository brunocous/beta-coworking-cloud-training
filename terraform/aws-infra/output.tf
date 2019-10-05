output "Airflow-web-ui-url" {
  value = join("", ["http://", aws_instance.airflow-instance.public_dns, ":8080"])
}


output "db-endpoint" {
  value = aws_db_instance.airflowdb.endpoint
}
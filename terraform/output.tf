output "url_web_ui_airflow" {
  value = module.aws-infra.Airflow-web-ui-url
}

output "db-endpoint" {
  value = module.aws-infra.db-endpoint
}
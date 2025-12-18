# outputs.tf
output "iceberg_public_ip" {
  value = aws_instance.iceberg.public_ip
}

output "iceberg_private_ip" {
  value = aws_instance.iceberg.private_ip
}

output "iceberg_jupyter_url" {
  value = "http://${aws_instance.iceberg.public_ip}:8888"
}

output "iceberg_trino_url" {
  value = "http://${aws_instance.iceberg.public_ip}:8080"
}

output "iceberg_superset_url" {
  value = "http://${aws_instance.iceberg.public_ip}:8088"
}

output "iceberg_dbeaver_url" {
  value = "http://${aws_instance.iceberg.public_ip}:8881"
}

output "iceberg_minio_url" {
  value = "http://${aws_instance.iceberg.public_ip}:9001"
}

output "airbyte_public_ip" {
  value = aws_instance.airbyte.public_ip
}

output "airbyte_private_ip" {
  value = aws_instance.airbyte.private_ip
}

output "airbyte_openmetadata_url" {
  value = "http://${aws_instance.airbyte.public_ip}:8585"
}

output "airbyte_airbyte_url" {
  value = "http://${aws_instance.airbyte.public_ip}:8000"
}

output "key_name" {
  value = aws_key_pair.default.key_name
}
output "dsn_article" {
  # ClusterIP
  value = "postgresql://${var.sql_user_name}@cockroachdb-public:8080/article?sslmode=disable"
}

output "dsn_tag" {
  # ClusterIP
  value = "postgresql://${var.sql_user_name}@cockroachdb-public:8080/tag?sslmode=disable"
}
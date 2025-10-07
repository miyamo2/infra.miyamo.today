output "dsn_article" {
  # ClusterIP
  value = "postgresql://${var.sql_user_name}@cockroachdb-public:26257/article?sslmode=disable"
}

output "dsn_tag" {
  # ClusterIP
  value = "postgresql://${var.sql_user_name}@cockroachdb-public:26257/tag?sslmode=disable"
}
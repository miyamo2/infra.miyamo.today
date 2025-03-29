output "dsn_article" {
  value     = data.cockroach_connection_string.article.connection_string
  sensitive = true
}

output "dsn_tag" {
  value     = data.cockroach_connection_string.tag.connection_string
  sensitive = true
}
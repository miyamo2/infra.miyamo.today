output "dsn_article" {
  value     = module.cockroach.dsn_article
  sensitive = true
}

output "dsn_tag" {
  value     = module.cockroach.dsn_tag
  sensitive = true
}


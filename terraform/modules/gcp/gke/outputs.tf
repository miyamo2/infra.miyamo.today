output "cluster_name" {
  value     = google_container_cluster.this.name
  sensitive = true
}

output "cluster_endpoint" {
  value     = google_container_cluster.this.endpoint
  sensitive = true
}

output "cluster_client_certificate" {
  value     = google_container_cluster.this.master_auth[0].cluster_ca_certificate
  sensitive = true
}

output "node_tag" {
  value = local.cluster_node_tag
}

output "config_context" {
  value = "gke_${google_container_cluster.this.project}_${google_container_cluster.this.location}_${google_container_cluster.this.name}"
}
locals {
  repository_names = [
    "article-service",
    "tag-service",
    "blogging-event-service",
    "federator"
  ]
}

resource "google_artifact_registry_repository" "this" {
  for_each      = toset(local.repository_names)
  project       = var.project_id
  repository_id = each.value
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}

resource "google_artifact_registry_repository_iam_member" "reader" {
  for_each   = google_artifact_registry_repository.this
  repository = each.value.id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com"
}

resource "google_service_account" "this" {
  account_id   = "gar-writer"
  display_name = "Artifact Registry Writer"
}

resource "google_artifact_registry_repository_iam_member" "writer" {
  for_each   = google_artifact_registry_repository.this
  repository = each.value.id
  role       = "roles/artifactregistry.writer"
  member     = google_service_account.this.member
}

resource "google_service_account_key" "this" {
  service_account_id = google_service_account.this.name
}


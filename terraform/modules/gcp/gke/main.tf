# GKE cluster resource
resource "google_container_cluster" "this" {
  name                = var.cluster_name
  project             = var.project_id
  deletion_protection = false

  addons_config {
    dns_cache_config {
      enabled = true
    }
    http_load_balancing {
      disabled = true
    }
  }

  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  datapath_provider  = "ADVANCED_DATAPATH"
  initial_node_count = 1

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/14"
    services_ipv4_cidr_block = "/20"
  }

  # note: for zonal cluster
  location = var.zone

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "All networks"
    }
  }
  network         = var.network_name
  networking_mode = "VPC_NATIVE"

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.100.0.0/28"
  }

  remove_default_node_pool = true

  release_channel {
    channel = "STABLE"
  }
  subnetwork = var.subnet_name
  workload_identity_config {
    workload_pool = format("%s.svc.id.goog", var.project_id)
  }
}

resource "google_service_account" "this" {
  account_id   = format("%s-nodepool-sa", google_container_cluster.this.name)
  display_name = "GKE Node Pool Service Account"
}

locals {
  nodepool_sa_roles = {
    node-service-account = {
      name = "node-searvice-account"
      role = "roles/container.nodeServiceAccount"
    },
    artifact-registry-reader = {
      name = "artifact-registry-reader"
      role = "roles/artifactregistry.reader"
    }
  }
  cluster_node_tag = format("%s-node", google_container_cluster.this.name)
}

resource "google_project_iam_member" "this" {
  project  = var.project_id
  for_each = local.nodepool_sa_roles
  role     = each.value.role
  member   = format("serviceAccount:%s", google_service_account.this.email)
}

resource "google_compute_firewall" "this" {
  name      = "node-allow-master-tcp8443"
  network   = var.network_name
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }
  source_ranges = ["10.100.0.0/28"]
  target_tags   = [local.cluster_node_tag]
}

resource "google_container_node_pool" "this" {
  cluster    = google_container_cluster.this.id
  node_count = var.node_count
  node_config {
    spot            = true
    machine_type    = var.machine_type
    disk_size_gb    = 20
    disk_type       = "pd-standard"
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    service_account = google_service_account.this.email
    tags            = [local.cluster_node_tag]
  }

  lifecycle {
    ignore_changes = [
      node_config[0].resource_labels,
      node_config[0].kubelet_config
    ]
  }
  depends_on = [google_project_iam_member.this, google_compute_firewall.this]
}

resource "terraform_data" "this" {
  provisioner "local-exec" {
    command = <<EOF
      gcloud container clusters get-credentials ${var.cluster_name} --zone=${var.zone}
    EOF
  }
  depends_on = [google_container_cluster.this]
}
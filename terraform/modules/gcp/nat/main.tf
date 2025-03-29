locals {
  caddy-sa-roles = {
    "compute-viewer" = {
      name = "compute-viewer"
      role = "roles/compute.viewer"
    },
    "log-writer" = {
      name = "log-writer"
      role = "roles/logging.logWriter"
    },
    "metrics-writer" = {
      name = "metrics-writer"
      role = "roles/monitoring.metricWriter"
    },
    "monitoring-viewer" = {
      name = "monitoring-viewer"
      role = "roles/monitoring.viewer"
    }
  }
}

resource "google_compute_address" "this" {
  name   = "caddy-ip"
  region = "us-west1"
}

resource "google_service_account" "this" {
  account_id   = "caddy-sa"
  display_name = "Caddy Service Account"
}

resource "google_project_iam_member" "this" {
  project  = var.project_id
  for_each = local.caddy-sa-roles
  role     = each.value.role
  member   = format("serviceAccount:%s", google_service_account.this.email)
}

resource "google_compute_instance" "this" {
  name                      = "caddy"
  project                   = var.project_id
  allow_stopping_for_update = true
  machine_type              = "e2-micro"
  zone                      = var.zone # free tier zone
  can_ip_forward            = true
  deletion_protection       = false
  network_interface {
    network    = var.network
    subnetwork = var.subnet
    # Assign an ephemeral public IP to this instance
    access_config {
      nat_ip = google_compute_address.this.address
    }
  }
  boot_disk {
    initialize_params {
      size  = 10
      type  = "pd-standard"
      image = "projects/cos-cloud/global/images/family/cos-stable"
    }
  }

  metadata = {
    "gce-container-declaration" = yamlencode({
      spec = {
        containers = [
          {
            name  = "caddy",
            image = "ghcr.io/cheap-k8s/cheap-k8s/caddy:latest",
            env = [
              {
                name  = "DOMAIN_NAMES",
                value = join(", ", var.domain_names)
              },
              {
                name  = "NODE_NAME_PREFIX",
                value = format("gke-%s", var.cluster_name)
              }
            ],
            securityContext = {
              privileged = false
            }
            stdin        = false
            tty          = false
            volumeMounts = []
          }
        ]
        volumes       = []
        restartPolicy = "Always"
      }
    })
    "google-logging-enabled"    = true
    "google-monitoring-enabled" = true
  }
  tags = ["allow-http", "allow-https", "allow-ssh"] # apply tags for firewall rules (http/ssh)
  service_account {
    email  = google_service_account.this.email
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = "sudo iptables -t nat -A POSTROUTING -o eth0 -s 10.0.0.0/8 -j MASQUERADE"
}

# Route to force cluster node internet traffic through the nat_lb instance
resource "google_compute_route" "this" {
  name              = "nat-route"
  project           = var.project_id
  network           = var.network
  dest_range        = "0.0.0.0/0"
  priority          = 500
  tags              = [var.node_tag] # Only instances with this network tag use this route
  next_hop_instance = google_compute_instance.this.self_link
}
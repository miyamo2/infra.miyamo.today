resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

# Create subnet for cluster and VM
resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.vpc_name}-subnet"
  project                  = var.project_id
  ip_cidr_range            = "10.128.0.0/12" # primary subnet for nodes and VM
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# Firewall rule: allow all intra-VPC traffic (so VM <-> nodes communication is open)
resource "google_compute_firewall" "allow-internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = ["10.128.0.0/12"] # allow all traffic within the subnet
}

# Firewall rule: allow HTTP to the ingress VM
resource "google_compute_firewall" "allow-http" {
  name    = "${var.vpc_name}-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http"] # attach this tag to the e2-micro instance
}

# Firewall rule: allow HTTP to the ingress VM
resource "google_compute_firewall" "allow-https" {
  name    = "${var.vpc_name}-allow-https"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-https"] # attach this tag to the e2-micro instance
}

# Firewall rule: allow SSH to VM (optional, for management)
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"] # (Lock this down to your IP range in real use)
  target_tags   = ["allow-ssh"] # will attach this tag to the VM
}
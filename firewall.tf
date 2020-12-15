resource "google_compute_firewall" "allow-https" {
  provider = google-beta
  name = "allow-https-rule"
  network = google_compute_network.frontend-network.id
  source_ranges = ["10.164.0.0/20"]
  allow {
    protocol = "tcp"
    ports = ["443"]
  }
  direction = "INGRESS"
}

resource "google_compute_firewall" "allow-ssh" {
  provider = google-beta
  name = "allow-ssh-rule"
  network = google_compute_network.backend-network.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  direction = "INGRESS"
}
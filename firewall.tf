resource "google_compute_firewall" "allow-https" {
  provider = google-beta
  name = "website-fw-4"
  network = google_compute_network.default.id
  source_ranges = ["10.164.0.0/20"]
  target_tags = ["load-balanced-frontend"]
  allow {
    protocol = "tcp"
    ports = ["443"]
  }
  direction = "INGRESS"
}
# NETWORKS
resource "google_compute_network" "frontend" {
    name = "frontend-network"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "frontend-sub" {
  name = "frontend-subnetwork"
  ip_cidr_range = "10.164.0.0/20"
  region = "europe-west4-a"
  network = "${google_compute_network.frontend.self_link}"
}

resource "google_compute_network" "backend" {
    name = "backend-network"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "backend-sub" {
  name = "backend-subnetwork"
  ip_cidr_range = "10.164.0.0/20"
  region = "europe-west4-a"
  network = "${google_compute_network.backend.self_link}"
}

resource "google_compute_network" "monitoring" {
    name = "monitoring-network"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "monitoring-sub" {
  name = "monitoring-subnetwork"
  ip_cidr_range = "10.164.0.0/20"
  region = "europe-west4-a"
  network = "${google_compute_network.monitoring.self_link}"
}

# PEERING

resource "google_compute_network_peering" "frontend-backend-peering" {
  name         = "frontend-backend-peering"
  network      = google_compute_network.frontend-network.id
  peer_network = google_compute_network.backend-network.id
}

#FORWARDING_RULES

resource "google_compute_forwarding_rule" "frontend-https" {
  provider = google-beta
  depends_on = [google_compute_subnetwork.proxy]
  name   = "frontend-https-forwarding-rule"
  region = "europe-west"

  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_region_target_http_proxy.frontend.id
  network               = google_compute_network.frontend-network.id
  subnetwork            = google_compute_subnetwork.frontend-subnetwork.id
}

resource "google_compute_region_target_http_proxy" "frontend" {
  provider = google-beta
  region  = "europe-west4-a"
  name    = "frontend-proxy"
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_region_url_map" "frontend" {
  provider = google-beta
  region          = "europe-west4-a"
  name            = "frontend-map"
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_backend_service" "frontend" {
  provider = google-beta
  load_balancing_scheme = "INTERNAL_MANAGED"
  backend {
    group = google_compute_region_instance_group_manager.rigm.instance_group
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }

  region      = "europe-west4-a"
  name        = "frontend-service"
  protocol    = "HTTPS"
  timeout_sec = 10
  health_checks = [google_compute_region_health_check.default.id]
}
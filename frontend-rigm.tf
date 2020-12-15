resource "google_compute_region_instance_group_manager" "frontend" {
  provider = google-beta
  region   = "europe-west4-a"
  name     = "frontend-rigm"
  version {
    instance_template = google_compute_instance_template.instance_template.id
    name              = "primary"
  }
  base_instance_name = "internal-lb-https"
  target_size        = 3
}

resource "google_compute_instance_template" "frontend_template" {
  provider     = google-beta
  name         = "frontend-instances"
  machine_type = "n1-standard-1"

  network_interface {
    network = google_compute_network.frontend-network.id
    subnetwork = google_compute_subnetwork.frontend-subnetwork.id
  }

  disk {
    source_image = data.google_compute_image.debian_image.self_link
    auto_delete  = true
    boot         = true
  }

  tags = ["allow-https"]
}
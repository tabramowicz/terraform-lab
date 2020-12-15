resource "google_compute_instance" "frontend" {
  count = "3"
  name = "frontend-${count.index+1}"
  machine_type = "n1-standard-1"
  zone = "europe-west4-a"
  can_ip_forward = "false"

    tags = [allow-https]


  boot_disk {
    initialize_parmas {
        image = "centos-7-v20201112"
    }
  }

  network_interface {
    network = "frontend-network"
    subnetwork = "frontend-subnetwork"
  }
}

resource "google_compute_target_pool" "frontend" {
  name = "frontend-instance-pool"

  instances = [
    "europe-west4-a/frontend-${count.index+1}",
  ]

  health_checks = [
    google_compute_http_health_check.default.name,
  ]
}

resource "google_compute_http_health_check" "default" {
  name               = "default"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
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

resource "google_dns_record_set" "frontend" {
  name = "frontend-1.${google_dns_managed_zone.prod.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.prod.name

  rrdatas = [google_compute_instance.frontend.network_interface[0].access_config[0].nat_ip]
}

resource "google_dns_record_set" "cname" {
  name         = "frontend-1.${google_dns_managed_zone.prod.dns_name}"
  managed_zone = google_dns_managed_zone.prod.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["frontend-1.domena.com."]
}

resource "google_dns_record_set" "cname" {
  name         = "frontend-2.${google_dns_managed_zone.prod.dns_name}"
  managed_zone = google_dns_managed_zone.prod.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["frontend-2.domena.com."]
}

resource "google_dns_record_set" "cname" {
  name         = "frontend-3.${google_dns_managed_zone.prod.dns_name}"
  managed_zone = google_dns_managed_zone.prod.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["frontend-3.domena.com."]
}

resource "google_dns_record_set" "cname" {
  name         = "frontend-4.${google_dns_managed_zone.prod.dns_name}"
  managed_zone = google_dns_managed_zone.prod.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["frontend-4.domena.com."]
}

resource "google_dns_managed_zone" "prod" {
  name     = "prod-zone"
  dns_name = "prod.domena.com"
}
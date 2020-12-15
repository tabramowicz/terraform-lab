resource "google_compute_instance" "db-master" {
  count = "1"
  name = "db-master"
  machine_type = "n1-standard-1"
  zone = "europe-west4-a"
  can_ip_forward = "false"

    tags = []


  boot_disk {
    initialize_parmas {
        image = "centos-7-v20201112"
    }
  }

  network_interface {
    network = "backend-network"
    subnetwork = "backend-subnetwork"
  }
}

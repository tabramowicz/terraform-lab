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

resource "google_compute_disk" "db-master" {
    name = "db-master-disk"
    type = "pd-ssd"
    zone = "europe-west4-a"
    size = "10"
}

resource "google_compute_attached_disk" "default" {
    disk = "${google_compute_disk.db-master-disk.self_link}"
    instance = "${google_compute_instance.db-master.self_link}"
}

resource "google_compute_instance" "db-slave" {
  count = "2"
  name = "db-slave-${index.count+1}"
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

resource "google_compute_disk" "db-slave" {
    name = "db-slave-disk"
    type = "pd-ssd"
    zone = "europe-west4-a"
    size = "10"
}

resource "google_compute_attached_disk" "default" {
    disk = "${google_compute_disk.db-slave-disk.self_link}"
    instance = "${google_compute_instance.db-slave[0].self_link}"
}
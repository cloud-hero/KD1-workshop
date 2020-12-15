resource "google_compute_instance" "node" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
      size  = "100"
    }
  }


  network_interface {
    network     = var.network
    subnetwork  = var.subnetwork
    access_config {}
    network_ip  = var.network_ip
  }

  metadata_startup_script = var.metadata_startup_script

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }
}
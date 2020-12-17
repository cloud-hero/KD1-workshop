resource "google_compute_network" "vpc" {
  name                    = "kube-vpc"
  auto_create_subnetworks = "false"
}

output "network_name" {
  value = google_compute_network.vpc.name
}
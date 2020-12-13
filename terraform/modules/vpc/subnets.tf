resource "google_compute_subnetwork" "k8s_subnet_1a" {
  name          = "kube-subnet-a"
  region        = "${var.region}"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_subnetwork" "k8s_subnet_1b" {
  name          = "kube-subnet-b"
  region        = "${var.region}"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.1.0.0/16"
}

resource "google_compute_subnetwork" "k8s_subnet_1c" {
  name          = "kube-subnet-c"
  region        = "${var.region}"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.2.0.0/16"
}

output "k8s_subnet_1a_name" {
  value = google_compute_subnetwork.k8s_subnet_1a.name
}

output "k8s_subnet_1b_name" {
  value = google_compute_subnetwork.k8s_subnet_1b.name
}

output "k8s_subnet_1c_name" {
  value = google_compute_subnetwork.k8s_subnet_1c.name
}
resource "google_compute_firewall" "allow-icmp" {
  name    = "k8s-allow-icmp"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}

resource "google_compute_firewall" "allow-internal" {
  name    = "k8s-allow-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.0.0/8"]
  priority = 65534
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "k8s-allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  priority = 65534
}
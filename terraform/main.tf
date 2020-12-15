provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
    source                  = "./modules/vpc"
    region                  = var.region
    project_id              = var.project_id
    gce_ssh_pub_key_file    = var.gce_ssh_pub_key_file
    gce_ssh_user            = var.gce_ssh_user
}

module "k8s-master-1" {
    source                  = "./modules/compute"
    name                    = "k8s-master-1"
    machine_type            = "n1-standard-2"
    network                 = module.vpc.network_name
    subnetwork              = module.vpc.k8s_subnet_1a_name
    network_ip              = "10.0.0.2"
    metadata_startup_script = "${file("bootstrap-kube.sh")}"
    zone                    = "${var.region}-a"
    gce_ssh_pub_key_file    = var.gce_ssh_pub_key_file
    gce_ssh_user            = var.gce_ssh_user
}

module "k8s-master-2" {
    source                  = "./modules/compute"
    name                    = "k8s-master-2"
    machine_type            = "n1-standard-2"
    network                 = module.vpc.network_name
    subnetwork              = module.vpc.k8s_subnet_1b_name
    network_ip              = "10.1.0.2"
    metadata_startup_script = "${file("bootstrap-kube.sh")}"
    zone                    = "${var.region}-b"
    gce_ssh_pub_key_file    = var.gce_ssh_pub_key_file
    gce_ssh_user            = var.gce_ssh_user
}

module "k8s-master-3" {
    source                  = "./modules/compute"
    name                    = "k8s-master-3"
    machine_type            = "n1-standard-2"
    network                 = module.vpc.network_name
    subnetwork              = module.vpc.k8s_subnet_1c_name
    network_ip              = "10.2.0.2"
    metadata_startup_script = "${file("bootstrap-kube.sh")}"
    zone                    = "${var.region}-c"
    gce_ssh_pub_key_file    = var.gce_ssh_pub_key_file
    gce_ssh_user            = var.gce_ssh_user
}

module "k8s-worker-1" {
    source                  = "./modules/compute"
    name                    = "k8s-worker-1"
    machine_type            = "n1-standard-1"
    network                 = module.vpc.network_name
    subnetwork              = module.vpc.k8s_subnet_1a_name
    network_ip              = "10.0.0.3"
    metadata_startup_script = "${file("bootstrap-kube.sh")}"
    zone                    = "${var.region}-a"
    gce_ssh_pub_key_file    = var.gce_ssh_pub_key_file
    gce_ssh_user            = var.gce_ssh_user
}

module "k8s-worker-2" {
    source                  = "./modules/compute"
    name                    = "k8s-worker-2"
    machine_type            = "n1-standard-1"
    network                 = module.vpc.network_name
    subnetwork              = module.vpc.k8s_subnet_1b_name
    network_ip              = "10.1.0.3"
    metadata_startup_script = "${file("bootstrap-kube.sh")}"
    zone                    = "${var.region}-b"
    gce_ssh_pub_key_file    = var.gce_ssh_pub_key_file
    gce_ssh_user            = var.gce_ssh_user
}

module "k8s-lb-1" {
    source                  = "./modules/compute"
    name                    = "k8s-lb-1"
    machine_type            = "n1-standard-1"
    network                 = module.vpc.network_name
    subnetwork              = module.vpc.k8s_subnet_1a_name
    network_ip              = "10.0.0.4"
    metadata_startup_script = "${file("bootstrap-nginx.sh")}"
    zone                    = "${var.region}-a"
    gce_ssh_pub_key_file    = var.gce_ssh_pub_key_file
    gce_ssh_user            = var.gce_ssh_user
}
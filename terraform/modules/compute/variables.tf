variable "name" {
    type = string
}

variable "machine_type" {
    type = string
}

variable "zone" {
    type = string
}

variable "gce_ssh_pub_key_file" {
    type = string
}

variable "gce_ssh_user" {
    type = string
}

variable "network" {}
variable "subnetwork" {}
variable "network_ip" {}
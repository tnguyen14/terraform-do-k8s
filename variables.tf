variable "region" {}

variable "cluster_name" {}

variable "worker_size" {
  default = "s-2vcpu-2gb"
}

variable "kubernetes_version" {
  default = "1.16.6-do.2"
}

variable "domain" {}

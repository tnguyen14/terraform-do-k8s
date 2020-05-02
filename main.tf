provider "digitalocean" {}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name    = var.cluster_name
  region  = var.region
  version = var.kubernetes_version

  node_pool {
    name = "autoscale-${var.cluster_name}-worker-pool"
    size = var.worker_size
    auto_scale = true
    min_nodes = 1
    max_nodes = 5
  }
}

provider "kubernetes" {
  load_config_file = false

  host  = digitalocean_kubernetes_cluster.k8s.endpoint
  token = digitalocean_kubernetes_cluster.k8s.kube_config[0].token

  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
  )
}

resource "digitalocean_certificate" "tls" {
  name    = "le-tls-${var.domain}"
  type    = "lets_encrypt"
  domains = [var.domain]

  lifecycle {
    create_before_destroy = true
  }
}

resource "digitalocean_loadbalancer" "lb" {
  name        = "${var.domain}-lb"
  region      = var.region
  droplet_tag = "k8s:${digitalocean_kubernetes_cluster.k8s.id}"

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 30080
    target_protocol = "http"

    certificate_id = digitalocean_certificate.tls.id
  }

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 30254
    protocol = "http"
    path    = "/healthz"
  }

  redirect_http_to_https = true
  # enable_proxy_protocol = true
}

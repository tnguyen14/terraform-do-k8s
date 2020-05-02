output "cluster_id" {
  value = digitalocean_kubernetes_cluster.k8s.id
}

output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s.endpoint
}

output "kubeconfig_token" {
  value = digitalocean_kubernetes_cluster.k8s.kube_config[0].token
}

output "kubeconfig_cluster_ca_certificate" {
  value = digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
}

output "lb_ip" {
  value = digitalocean_loadbalancer.lb.ip
}

# Digital Ocean Kubernetes cluster

Terraform module to create a kubernetes cluster on Digital Ocean, fronted by a Load Balancer, with TLS support.

## Architecture

Incoming Request -> DO LB -> Worker:NodePort -> Ingress Service -> NGINX Controller -> App Service -> Pod

## Features

- [nginx Ingress controller](https://github.com/kubernetes/ingress-nginx)
- Incoming HTTP traffic (80) is redirected to HTTPS (443)
- TLS/SSL termination with managed Let's Encrypt cert

## Limitations

- DigitalOcean load balancer only supports a single domain. If there are multiple domains pointing to the cluster, each of them would need its own load balancer.

## Debugging

NGINX logs

```
kubectl logs -f -n ingress-nginx $(kubectl get pods -n ingress-nginx -o name)
```

Interactive session to NGINX

```
kubectl exec -n ingress-nginx -it $(kubectl get pod -n ingress-nginx -o name) -- bash
```

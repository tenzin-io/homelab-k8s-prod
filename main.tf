terraform {
  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/homelab-k8s-prod.state"
    dynamodb_table = "tenzin-io"
    region         = "us-east-1"
  }
}

module "cert_manager" {
  source                  = "git::https://github.com/tenzin-io/terraform-tenzin-cert-manager.git?ref=v0.0.2"
  cert_registration_email = "tenzin@tenzin.io"
  cloudflare_api_token    = data.vault_generic_secret.cloudflare.data.api_token
}

module "github_actions" {
  source                     = "git::https://github.com/tenzin-io/terraform-tenzin-github-actions-runner-controller.git?ref=v0.2.0"
  github_org_name            = "tenzin-io"
  github_app_id              = data.vault_generic_secret.github_app.data.app_id
  github_app_installation_id = data.vault_generic_secret.github_app.data.installation_id
  github_app_private_key     = data.vault_generic_secret.github_app.data.private_key
  github_runner_labels       = ["homelab"]
  github_runner_image        = "containers.tenzin.io/docker/tenzin-io/actions-runner-images/ubuntu-latest:v0.0.9"
  depends_on                 = [module.cert_manager, module.nfs_subdir]
}

module "metallb" {
  source        = "git::https://github.com/tenzin-io/terraform-tenzin-metallb.git?ref=v0.0.1"
  ip_pool_range = "192.168.200.70/32"
}

module "nginx_ingress" {
  source                  = "git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-controller.git?ref=v0.0.2"
  enable_tailscale_tunnel = true
  tailscale_auth_key      = data.vault_generic_secret.tailscale.data.auth_key
  depends_on              = [module.metallb]
}

module "homelab_services" {
  source = "git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-external.git?ref=v0.1.0"
  external_services = {
    "homelab-vsphere" = {
      virtual_host = "vs.tenzin.io"
      address      = "192.168.200.223"
      protocol     = "HTTPS"
      port         = "443"
    }
  }
  depends_on = [module.nginx_ingress, module.cert_manager]
}

module "nfs_subdir" {
  source     = "git::https://github.com/tenzin-io/terraform-tenzin-nfs-subdir.git?ref=v0.0.4"
  nfs_server = "zfs-1.tenzin.io"
  nfs_path   = "/data/homelab-k8s-prod"
}

module "prometheus" {
  source                  = "git::https://github.com/tenzin-io/terraform-tenzin-prometheus.git?ref=main"
  alert_receiver_name     = "xmatters"
  alert_receiver_username = data.vault_generic_secret.xmatters.data.username
  alert_receiver_password = data.vault_generic_secret.xmatters.data.password
  alert_receiver_url      = data.vault_generic_secret.xmatters.data.trigger_url
  kubernetes_cluster_name = "homelab-k8s-prod"
  prometheus_volume_size  = "30Gi"
  certificate_issuer_name = "lets-encrypt"
  thanos_ingress_host     = "homelab-k8s-prod-thanos.tenzin.io"
  depends_on              = [module.nginx_ingress, module.cert_manager, module.nfs_subdir]
}

module "grafana" {
  source                     = "git::https://github.com/tenzin-io/terraform-tenzin-grafana.git?ref=v0.0.2"
  grafana_ingress_host       = "grafana.tenzin.io"
  certificate_issuer_name    = "lets-encrypt"
  github_org_name            = "tenzin-io"
  github_oauth_client_id     = data.vault_generic_secret.grafana.data.github_oauth_client_id
  github_oauth_client_secret = data.vault_generic_secret.grafana.data.github_oauth_client_secret
  thanos_store_endpoints     = ["homelab-k8s-prod-thanos.tenzin.io:443"]
  depends_on                 = [module.nginx_ingress, module.cert_manager, module.prometheus, module.nfs_subdir]
}

module "artifactory" {
  source                  = "git::https://github.com/tenzin-io/terraform-tenzin-artifactory-jcr.git?ref=main"
  certificate_issuer_name = "lets-encrypt"
  jcr_ingress_host        = "containers.tenzin.io"
  depends_on              = [module.nginx_ingress, module.cert_manager, module.nfs_subdir]
}

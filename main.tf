terraform {
  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/homelab-k8s-v1.state"
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
  source                     = "git::https://github.com/tenzin-io/terraform-tenzin-github-actions-runner-controller.git?ref=v0.1.0"
  github_org_name            = "tenzin-io"
  github_app_id              = data.vault_generic_secret.github_app.data.app_id
  github_app_installation_id = data.vault_generic_secret.github_app.data.installation_id
  github_app_private_key     = data.vault_generic_secret.github_app.data.private_key
  github_runner_labels       = ["homelab", "v1"]
  github_runner_image        = "containers.tenzin.io/docker/tenzin-io/actions-runner-images/ubuntu-latest:v0.0.2"
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
    "homelab-artifactory" = {
      virtual_host      = "containers.tenzin.io"
      address           = "192.168.200.226"
      protocol          = "HTTP"
      port              = "8082"
      request_body_size = "24g"
    }
  }
  depends_on = [module.nginx_ingress, module.cert_manager]
}

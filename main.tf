terraform {
  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/homelab-github-actions-runner.state"
    dynamodb_table = "tenzin-io"
    region         = "us-east-1"
  }
}

module "cert_manager" {
  source                  = "git::https://github.com/tenzin-io/terraform-tenzin-cert-manager.git?ref=v0.0.2"
  cert_registration_email = "tenzin@tenzin.io"
  cloudflare_api_token    = chomp(data.aws_ssm_parameter.cloudflare_api_token.value)
}

module "github_actions" {
  source                     = "git::https://github.com/tenzin-io/terraform-tenzin-github-actions-runner-controller.git?ref=main"
  github_org_name            = "tenzin-io"
  github_app_id              = chomp(data.aws_ssm_parameter.github_app_id.value)
  github_app_installation_id = chomp(data.aws_ssm_parameter.github_app_installation_id.value)
  github_app_private_key     = data.aws_ssm_parameter.github_app_private_key.value
  github_runner_labels       = "homelab,v1"
  github_runner_image        = "containers.tenzin.io/docker/tenzin-io/actions-runner:latest"
  #github_runner_image = "ghcr.io/actions/actions-runner-controller/actions-runner-dind:ubuntu-22.04"

}

module "metallb" {
  source        = "git::https://github.com/tenzin-io/terraform-tenzin-metallb.git?ref=v0.0.1"
  ip_pool_range = "192.168.200.70/32"
}

module "nginx_ingress" {
  source                  = "git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-controller.git?ref=v0.0.2"
  enable_tailscale_tunnel = true
  tailscale_auth_key      = chomp(data.aws_ssm_parameter.tailscale_auth_key.value)
  depends_on              = [module.metallb]
}

module "homelab_services" {
  source = "git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-external.git?ref=main"
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

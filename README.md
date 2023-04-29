# README
A Terraform configuration repository to manage my home lab Kubernetes cluster

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.65.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | git::https://github.com/tenzin-io/terraform-tenzin-cert-manager.git | v0.0.2 |
| <a name="module_github_actions"></a> [github\_actions](#module\_github\_actions) | git::https://github.com/tenzin-io/terraform-tenzin-github-actions-runner-controller.git | v0.1.0 |
| <a name="module_homelab_services"></a> [homelab\_services](#module\_homelab\_services) | git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-external.git | v0.1.0 |
| <a name="module_metallb"></a> [metallb](#module\_metallb) | git::https://github.com/tenzin-io/terraform-tenzin-metallb.git | v0.0.1 |
| <a name="module_nginx_ingress"></a> [nginx\_ingress](#module\_nginx\_ingress) | git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-controller.git | v0.0.2 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.cloudflare_api_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_app_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_app_installation_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_app_private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.tailscale_auth_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
<!-- END_TF_DOCS -->

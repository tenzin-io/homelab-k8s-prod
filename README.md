# README
A Terraform configuration repository to manage my home lab Kubernetes cluster

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.62.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | git@github.com:tenzin-io/terraform-homelab-cert-manager.git | main |
| <a name="module_github_actions_runner"></a> [github\_actions\_runner](#module\_github\_actions\_runner) | git@github.com:tenzin-io/terraform-homelab-github-actions-runner-controller.git | main |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.cloudflare_api_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_app_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_app_installation_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_app_private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
<!-- END_TF_DOCS -->

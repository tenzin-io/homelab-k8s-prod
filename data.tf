data "aws_ssm_parameter" "github_app_id" {
  name = "/homelab/github_app_id"
}

data "aws_ssm_parameter" "github_app_installation_id" {
  name = "/homelab/github_app_installation_id"
}

data "aws_ssm_parameter" "github_app_private_key" {
  name = "/homelab/github_app_private_key"
}

data "aws_ssm_parameter" "cloudflare_api_token" {
  name = "/homelab/cloudflare_api_token"
}

data "aws_ssm_parameter" "tailscale_auth_key" {
  name = "/homelab/tailscale_auth_key"
}

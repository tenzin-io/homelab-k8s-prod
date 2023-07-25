data "vault_generic_secret" "github_app" {
  path = "secrets/github_app"
}

data "vault_generic_secret" "cloudflare" {
  path = "secrets/cloudflare"
}

data "vault_generic_secret" "tailscale" {
  path = "secrets/tailscale"
}

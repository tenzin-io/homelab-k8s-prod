data "vault_generic_secret" "github_app" {
  path = "github/github_app"
}

data "vault_generic_secret" "cloudflare" {
  path = "github/cloudflare"
}

data "vault_generic_secret" "tailscale" {
  path = "github/tailscale"
}

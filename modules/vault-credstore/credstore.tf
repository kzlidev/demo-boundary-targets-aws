resource "vault_token" "boundary" {
  count = length(var.boundary_projects)
  policies = [vault_policy.boundary-controller.name,
    vault_policy.db-read.name,
    vault_policy.kv-read.name,
    vault_policy.k8s-roles.name,
    vault_policy.boundary-client.name
  ]

  no_parent         = true
  no_default_policy = true
  renewable         = true
  ttl               = "20m"
  period            = "20m"

  metadata = {
    "purpose" = "boundary-service-account-${var.boundary_projects[count.index]}"
  }
}

resource "boundary_credential_store_vault" "cred_store" {
  count           = length(var.boundary_projects)
  name            = "vault-cred-store-${var.boundary_projects[count.index]}"
  description     = "Vault credential store!"
  address         = var.vault_addr
  token           = vault_token.boundary[count.index].client_token
  scope_id        = var.boundary_projects[count.index]
  tls_skip_verify = true
  worker_filter   = "\"ingress\" in \"/tags/worker-type\""
}



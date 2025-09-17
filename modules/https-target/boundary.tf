resource "boundary_host_catalog_static" "https_server" {
  name        = "https_servers"
  description = "https servers"
  scope_id    = var.boundary_project_id
}

resource "boundary_host_static" "https_servers" {
  name            = "https_server_1"
  description     = "HTTPS Instance #1"
  address         = aws_instance.hashicat.private_ip
  host_catalog_id = boundary_host_catalog_static.https_server.id
}

resource "boundary_host_set_static" "https_servers" {
  name            = "https_host_set"
  description     = "Host set for HTTPS servers"
  host_catalog_id = boundary_host_catalog_static.https_server.id
  host_ids        = [boundary_host_static.https_servers.id]
}

resource "boundary_role" "https_user" {
  name            = "https_user"
  description     = "Access to https hosts for user role"
  scope_id        = var.boundary_org_id
  grant_scope_ids = [var.boundary_project_id]
  grant_strings   = [
    "ids=${boundary_target.https_user.id};actions=read,authorize-session",
    "ids=${boundary_host_static.https_servers.id};actions=read",
    "ids=${boundary_host_set_static.https_servers.id};actions=read",
    "ids=*;type=target;actions=list,no-op",
    "ids=*;type=auth-token;actions=list,read:self,delete:self"
  ]
  principal_ids = var.allowed_principal_ids
}

resource "boundary_target" "https_user" {
  type                     = "tcp"
  name                     = "https_user"
  description              = "HTTPS web access for user"
  scope_id                 = var.boundary_project_id
  session_connection_limit = -1
  default_port             = 443
  # default_client_port      = 443
  ingress_worker_filter    = "\"ingress\" in \"/tags/worker-type\""
#  egress_worker_filter     = "\"egress\" in \"/tags/type\""
  host_source_ids          = [
    boundary_host_set_static.https_servers.id
  ]
  # brokered_credential_source_ids = [ boundary_credential_username_password.static_win_creds.id ]
}

resource "boundary_alias_target" "https_alias_target" {
  name                      = "https_alias_target"
  description               = "Alias to target HTTPS using host https.boundary"
  scope_id                  = "global"
  value                     = "https.boundary"
  destination_id            = boundary_target.https_user.id
  authorize_session_host_id = boundary_host_static.https_servers.id
}

# resource "boundary_credential_username_password" "static_win_creds" {
#   name                = "static_windows_creds"
#   description         = "Windows credentials"
#   credential_store_id = var.boundary_resources.static_credstore_id
#   username            = "Administrator"
#   password            = rsadecrypt(aws_instance.windows.password_data, file("${path.root}/generated/rsa_key"))
# }

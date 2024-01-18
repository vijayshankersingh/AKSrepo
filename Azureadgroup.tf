
resource "azuread_group" "akvgroup" {
  display_name     = "akvgroup"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [var.userid]  
}
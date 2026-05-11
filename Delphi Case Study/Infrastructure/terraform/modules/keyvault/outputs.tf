output "key_vault_id" {
  value       = azurerm_key_vault.kv.id
  description = "Key Vault ID"
}

output "key_vault_name" {
  value       = azurerm_key_vault.kv.name
  description = "Key Vault name"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.kv.vault_uri
  description = "Key Vault URI"
}

output "key_vault_resource_id" {
  value       = azurerm_key_vault.kv.id
  description = "Key Vault resource ID"
}

output "private_endpoint_id" {
  value       = azurerm_private_endpoint.kv_pe.id
  description = "Private endpoint ID"
}

output "private_dns_zone_id" {
  value       = azurerm_private_dns_zone.kv_dns.id
  description = "Private DNS zone ID"
}

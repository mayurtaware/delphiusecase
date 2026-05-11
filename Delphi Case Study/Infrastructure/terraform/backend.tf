// Remote backend configuration for Terraform state management
// Uncomment and configure the following when you have set up a remote state backend
// This ensures team collaboration and state locking


terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "deltfstatestorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# To initialize with remote backend, run:
# terraform init -backend-config="resource_group_name=rg-terraform-state" \
 #              -backend-config="storage_account_name=deltfstatestorageaccount" \
 #              -backend-config="container_name=tfstate" \
 #              -backend-config="key=prod.terraform.tfstate"
*/

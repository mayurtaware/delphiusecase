# Delphi Case Study - Azure Infrastructure Deployment

Complete Terraform infrastructure-as-code setup for deploying production-ready Azure resources with high availability, security, and networking best practices.

## 📋 Overview

This repository contains modular Terraform code to deploy the following Azure resources:

- **Azure Kubernetes Service (AKS)** - Container orchestration with multi-node pools
- **Azure Container Registry (ACR)** - Secure container image storage and management
- **Azure Key Vault** - Secrets and encryption key management
- **Azure App Service** - Managed hosting for web applications
- **Virtual Network** - Custom networking with subnets and security groups

## 🏗️ Architecture

```
Azure Resources
├── Resource Group
│   ├── Virtual Network (10.0.0.0/8)
│   │   ├── AKS Subnet (10.1.0.0/16)
│   │   │   ├── AKS Cluster (Multi-AZ)
│   │   │   │   ├── Default Node Pool
│   │   │   │   ├── System Node Pool
│   │   │   │   └── Application Node Pool
│   │   │   └── Network Security Group
│   │   │
│   │   └── App Service Subnet (10.2.0.0/16)
│   │       ├── App Service Plan (Zone-redundant)
│   │       ├── App Service (Multi-instance)
│   │       └── Network Security Group
│   │
│   ├── Container Registry (Premium)
│   │   ├── Georeplication
│   │   └── Private Endpoint
│   │
│   └── Key Vault (Premium)
│       ├── Encryption Keys
│       ├── Secrets
│       └── Private Endpoint
```

## 🔒 Security Features

- **Network Security Groups** with restrictive ingress rules
- **Private Endpoints** for ACR and Key Vault
- **Azure Private DNS Zones** for private connectivity
- **Network Policies** enforced in AKS
- **RBAC** role-based access control
- **Key Vault** with purge protection and soft delete
- **Managed Identity** for service-to-service authentication
- **TLS 1.2+** enforced across all services
- **Workload Identity** for pod authentication
- **Azure Policy** enforcement on AKS

## 🚀 High Availability Features

- **AKS Multi-AZ** deployment across availability zones
- **Auto-scaling** for AKS nodes and App Service instances
- **Multiple node pools** (default, system, application)
- **Zone-redundant** App Service Plan
- **Georeplication** for ACR
- **Health checks** configured for App Service
- **Managed identities** for resilient authentication

## 📁 Project Structure

```
Infrastructure/
├── terraform/
│   ├── main.tf              # Main resource orchestration
│   ├── provider.tf          # Azure provider configuration
│   ├── variables.tf         # Input variables
│   ├── outputs.tf           # Output values
│   ├── backend.tf           # Terraform state backend
│   ├── terraform.tfvars     # Variable values (EDIT THIS)
│   │
│   └── modules/
│       ├── networking/      # VNet, subnets, NSGs
│       ├── aks/            # Kubernetes cluster
│       ├── acr/            # Container registry
│       ├── keyvault/       # Secrets and encryption
│       └── app_service/    # Web app hosting

Pipelines/
├── infrastructure-deployment.yml   # Main deployment pipeline
├── app-build-and-deploy.yml       # Docker build and AKS deployment
├── infrastructure-destroy.yml      # Infrastructure destruction
└── terraform-quality-gate.yml     # Linting and format checks
```

## 📋 Prerequisites

- Azure subscription with appropriate permissions
- Terraform >= 1.0
- Azure CLI
- Azure DevOps project
- Service Principal with Owner role on subscription

## 🔧 Setup Instructions

### 1. Configure Terraform Variables

Edit `Infrastructure/terraform/terraform.tfvars`:

```hcl
subscription_id        = "YOUR_SUBSCRIPTION_ID"
resource_group_name    = "rg-delphi-prod"
location              = "East US"
environment           = "prod"
registry_name         = "delphi-app-registry"
key_vault_name        = "delphi-prod-kv"
app_service_name      = "delphi-app-service"
```

### 2. Set Up Remote State Backend

Create a storage account for Terraform state:

```bash
# Create resource group
az group create \
  --name rg-terraform-state \
  --location eastus

# Create storage account
az storage account create \
  --name tfstateaccount \
  --resource-group rg-terraform-state \
  --location eastus \
  --sku Standard_GRS

# Create container
az storage container create \
  --name tfstate \
  --account-name tfstateaccount

# Get storage account key
az storage account keys list \
  --account-name tfstateaccount \
  --query "[0].value" -o tsv
```

Enable the backend in `backend.tf`.

### 3. Initialize Terraform

```bash
cd Infrastructure/terraform

terraform init \
  -backend-config="resource_group_name=rg-terraform-state" \
  -backend-config="storage_account_name=tfstateaccount" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=prod.tfstate"
```

### 4. Review and Apply

```bash
# Review the plan
terraform plan -var-file=terraform.tfvars -out=tfplan

# Apply the configuration
terraform apply tfplan
```

### 5. Configure Azure DevOps Pipelines

1. Create Service Connection:
   - Go to Project Settings → Service Connections
   - Create "Azure Resource Manager" connection
   - Name it "Azure-Subscription"
   - Set scope to your subscription

2. Create Pipelines:
   - New Pipeline → GitHub/Azure Repos
   - Select this repository
   - For each YAML file in `Pipelines/`:
     - Create new pipeline
     - Point to the YAML file
     - Save

3. Configure Pipeline Variables:
   - Set `azureSubscription` to your service connection name
   - Set `resourceGroupName` to match your environment
   - Set `dockerRegistryServiceConnection` to your ACR

## 📦 Module Outputs

After deployment, key outputs are available:

```bash
# Get AKS credentials
terraform output -raw kube_config_raw > ~/.kube/config

# Get ACR login server
terraform output acr_login_server

# Get Key Vault URI
terraform output key_vault_uri

# Get App Service URL
terraform output app_service_default_hostname
```

## 🔐 Accessing Resources

### AKS Cluster
```bash
# Get kubeconfig
az aks get-credentials \
  --resource-group rg-delphi-prod \
  --name prod-aks-cluster

# Verify access
kubectl get nodes
```

### Container Registry
```bash
# Login to ACR
az acr login --name delphiappregistry

# Push image
az acr build \
  --registry delphiappregistry \
  --image delphi-app:latest .
```

### Key Vault
```bash
# List secrets
az keyvault secret list --vault-name delphi-prod-kv

# Get secret
az keyvault secret show \
  --vault-name delphi-prod-kv \
  --name db-connection-string
```

## 🔄 CI/CD Pipeline Workflows

### Infrastructure Deployment Pipeline
- Triggered on push to main/develop
- Validates Terraform configuration
- Runs security scan (TFSec)
- Plans changes
- Requires approval for production
- Applies Terraform changes
- Publishes outputs

### Application Build Pipeline
- Triggered on app code changes
- Builds .NET application
- Runs unit tests
- Builds Docker image
- Pushes to ACR
- Scans image for vulnerabilities (Trivy)
- Deploys to AKS

### Quality Gate Pipeline
- Runs on PRs
- Validates Terraform format
- Runs TFLint checks
- Generates documentation
- Validates configuration syntax

## 📊 Monitoring and Logging

All resources include:
- Azure Monitor integration
- Application Insights (App Service)
- Diagnostic Settings
- Log Analytics Workspace configuration
- Resource-level metrics

## 🛡️ Compliance and Best Practices

- ✅ Zone redundancy for high availability
- ✅ Network policies and NSGs
- ✅ RBAC with least privilege
- ✅ Private endpoints for sensitive services
- ✅ Encryption at rest and in transit
- ✅ Secrets management via Key Vault
- ✅ Regular backups enabled
- ✅ Audit logging configured
- ✅ Tags for resource management
- ✅ Cost optimization through auto-scaling

## 🧹 Cleanup

To destroy all infrastructure:

```bash
# Using pipeline (recommended for production)
# Manually trigger infrastructure-destroy.yml

# Or using Terraform directly
terraform destroy -var-file=terraform.tfvars
```

## 🐛 Troubleshooting

### Terraform State Lock
```bash
# Unlock state if stuck
terraform force-unlock <LOCK_ID>
```

### AKS Cluster Access Issues
```bash
# Get cluster admin credentials
az aks get-credentials \
  --resource-group rg-delphi-prod \
  --name prod-aks-cluster \
  --admin
```

### ACR Authentication Issues
```bash
# Check role assignments
az role assignment list --scope /subscriptions/<id>/resourceGroups/rg-delphi-prod
```

### Key Vault Access Denied
```bash
# Check network rules
az keyvault network-rule list --name delphi-prod-kv
```

## 📝 Common Tasks

### Scale AKS Node Pool
```hcl
# Edit terraform.tfvars
aks_max_node_count = 10  # Increase max nodes
```

### Add Environment-Specific Variables
```bash
# Create environment-specific tfvars
cp terraform.tfvars terraform.staging.tfvars

# Apply with environment variable
terraform apply -var-file=terraform.staging.tfvars
```

### Update Container Image
The ACR webhook triggers AKS deployments on new image push.

## 📚 Documentation

See individual module READMEs:
- [Networking Module](./modules/networking/README.md)
- [AKS Module](./modules/aks/README.md)
- [ACR Module](./modules/acr/README.md)
- [Key Vault Module](./modules/keyvault/README.md)
- [App Service Module](./modules/app_service/README.md)

## 🤝 Contributing

1. Create a feature branch
2. Make changes
3. Submit PR with description
4. Pipeline validation runs automatically
5. Merge after approval

## 📞 Support

For issues or questions:
- Check Terraform logs: `TF_LOG=DEBUG terraform apply`
- Review Azure DevOps pipeline logs
- Check Azure portal for resource-specific errors

## 📄 License

[Your License Here]

## 🎯 Next Steps

1. ✅ Configure `terraform.tfvars`
2. ✅ Set up remote state backend
3. ✅ Create Azure DevOps service connections
4. ✅ Create pipelines from YAML files
5. ✅ Trigger infrastructure deployment
6. ✅ Configure application deployment
7. ✅ Set up monitoring and alerts

---

**Last Updated:** 2024
**Terraform Version:** 1.5+
**Azure Provider Version:** 3.0+

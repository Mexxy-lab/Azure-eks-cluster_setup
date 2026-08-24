# Azure AKS Cluster Setup with Terraform

## Overview

This Terraform project provisions an **Azure Kubernetes Service (AKS)** cluster and its supporting Azure infrastructure using a modular Terraform architecture.

The project is designed to provide an infrastructure structure similar to the AWS EKS Terraform project, while using Azure-native resources and terminology.

The infrastructure includes:

* **Terraform State Module**: Creates an Azure Resource Group, Storage Account, and Blob Container for remote Terraform state.
* **VNet Module**: Creates an Azure Virtual Network with public and private subnets.
* **AKS Cluster Module**: Provisions the AKS control plane and system node pool.
* **AKS Node Group Module**: Creates an additional managed user node pool for Kubernetes workloads.
* **Azure Managed Identity**: AKS uses a system-assigned managed identity.
* **Azure Workload Identity / OIDC**: Enabled for future integration between Kubernetes workloads and Azure resources.

---

## Repository

GitHub repository:

<https://github.com/Mexxy-lab/Azure-eks-cluster_setup.git>

> **Note:** The repository name contains `eks` for historical consistency with the original AWS project. The Azure Kubernetes service being deployed is **AKS — Azure Kubernetes Service**, not EKS.

---

## Architecture

The Terraform configuration creates the following infrastructure:

```text
Azure Subscription
│
├── Terraform State Resource Group
│   │
│   └── Storage Account
│       │
│       └── Blob Container
│           └── Terraform State
│
└── AKS Resource Group
    │
    ├── Azure VNet
    │   │
    │   ├── Public Subnet
    │   │
    │   └── Private Subnet
    │       │
    │       ├── AKS System Node Pool
    │       │   └── 2 Nodes
    │       │
    │       └── AKS Worker Node Pool
    │           └── 2 Nodes
    │
    └── AKS Cluster
        │
        ├── Kubernetes Control Plane
        │
        ├── System Node Pool
        │
        └── Worker Node Pool
```

---

## Project Structure

```text
azure-aks-cluster_setup/
│
├── README.md
├── backend.tf
├── main.tf
├── outputs.tf
├── variables.tf
├── terraform.tfvars
├── versions.tf
│
└── modules/
    │
    ├── aks-cluster/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    │
    ├── aks-node-group/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    │
    ├── terraform-state/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    │
    └── vnet/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

---

## Prerequisites

Before deploying the infrastructure, make sure the following tools are installed.

## Azure CLI

Verify:

```bash
az version
```

If Azure CLI is not installed, install it using the official Azure CLI installation instructions.

## Terraform

Verify:

```bash
terraform version
```

Terraform 1.6 or newer is recommended for this project.

## kubectl

Verify:

```bash
kubectl version --client
```

`kubectl` is required to interact with the AKS cluster after deployment.

---

## Azure Authentication

This project uses Azure authentication rather than AWS credentials.

Login to Azure:

```bash
az login
```

Verify the currently authenticated account:

```bash
az account show
```

Display available subscriptions:

```bash
az account list -o table
```

If you have multiple subscriptions, select the subscription that should contain the AKS infrastructure:

```bash
az account set --subscription "<SUBSCRIPTION_ID>"
```

Verify the selected subscription:

```bash
az account show -o table
```

You can also retrieve the subscription ID:

```bash
az account show --query id -o tsv
```

Retrieve the tenant ID:

```bash
az account show --query tenantId -o tsv
```

These values are used by Terraform for Azure authentication.

---

## Configuration

Update the root `terraform.tfvars` file with your Azure environment values.

Example:

```hcl
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

tenant_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

location = "East US"

resource_group_name = "pumej-aks-rg"

tfstate_resource_group_name = "pumej-terraform-state-rg"

terraform_state_storage_account = "pumejaksstate2026"

terraform_state_container = "tfstate"

vnet_name = "pumej-aks-vnet"

vnet_address_space = [
  "10.0.0.0/16"
]

public_subnet_name = "public-subnet"

public_subnet_cidr = "10.0.1.0/24"

private_subnet_name = "private-subnet"

private_subnet_cidr = "10.0.2.0/24"

aks_cluster_name = "pumej-aks"

kubernetes_version = "1.33"

system_node_count = 2

system_vm_size = "Standard_D2s_v5"

node_pool_name = "worker"

worker_vm_size = "Standard_D2s_v5"

worker_node_count = 2
```

### Important

Azure Storage Account names must be globally unique.

For example:

```text
pumejaksstate2026
```

may already be in use.

If so, choose another globally unique name:

```text
pumejaksstate2026xyz
```

Do not use spaces, uppercase letters, or special characters in the Storage Account name.

---

## Terraform Modules

## Terraform State Module

The Terraform State module creates:

* Azure Resource Group
* Azure Storage Account
* Azure Blob Container
* Blob versioning
* Storage security configuration
* Storage Blob Data Contributor role assignment

The Azure Blob Container stores the Terraform state remotely.

Example:

```text
Storage Account
└── tfstate
    └── aks-cluster/
        └── terraform.tfstate
```

---

## VNet Module

The VNet module creates:

```text
VNet
└── 10.0.0.0/16
    │
    ├── public-subnet
    │   └── 10.0.1.0/24
    │
    └── private-subnet
        └── 10.0.2.0/24
```

The private subnet is used by the AKS nodes.

---

## AKS Cluster Module

The AKS module creates the AKS cluster and its required system node pool.

The configuration includes:

* AKS cluster
* System-assigned managed identity
* System node pool
* Azure CNI networking
* Azure network policy
* Kubernetes service CIDR
* Kubernetes DNS service IP
* OIDC issuer
* Workload Identity
* Standard Load Balancer

---

## AKS Node Group Module

Azure refers to EKS-style worker groups as **AKS node pools**.

The project creates an additional user node pool:

```text
worker
```

This node pool is intended for application workloads.

Example:

```text
AKS
│
├── system
│   └── 2 nodes
│
└── worker
    └── 2 nodes
```

---

## Initial Terraform State Bootstrap

There is one important difference between the Terraform state configuration and the rest of the infrastructure.

The Azure Storage Account used by the remote backend must exist **before** Terraform can initialize the Azure backend.

Therefore, the first deployment requires a bootstrap process.

## Step 1 — Authenticate to Azure

```bash
az login
```

Verify:

```bash
az account show
```

---

## Step 2 — Temporarily Disable the Backend

Before the first deployment, temporarily rename `backend.tf`:

```bash
mv backend.tf backend.tf.disabled
```

Initialize Terraform:

```bash
terraform init
```

Terraform will initially use local state.

---

## Step 3 — Create the Terraform State Infrastructure

Create only the Terraform state resources:

```bash
terraform apply -target=module.terraform_state
```

This creates:

```text
pumej-terraform-state-rg
│
└── Storage Account
    │
    └── tfstate
```

Confirm that the Storage Account exists:

```bash
az storage account show \
  --name <STORAGE_ACCOUNT_NAME> \
  --resource-group <STATE_RESOURCE_GROUP> \
  --query name \
  -o tsv
```

Verify the Blob Container:

```bash
az storage container list \
  --account-name <STORAGE_ACCOUNT_NAME> \
  --auth-mode login \
  -o table
```

---

## Enable the Azure Remote Backend

Once the Terraform state Storage Account and Blob Container exist, restore `backend.tf`:

```bash
mv backend.tf.disabled backend.tf
```

Initialize Terraform again:

```bash
terraform init -migrate-state
```

Terraform will detect the existing local state and ask whether it should migrate the state to the Azure backend.

Answer:

```text
yes
```

After this, Terraform state will be stored remotely in Azure Blob Storage.

---

## Deploy the AKS Infrastructure

Once the Azure backend is initialized:

## Validate the configuration

```bash
terraform fmt -recursive
```

Then:

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

---

## Review the deployment

```bash
terraform plan
```

Review the resources Terraform plans to create.

---

## Deploy

```bash
terraform apply
```

Review the plan and enter:

```text
yes
```

Terraform will create:

* Resource Group
* VNet
* Public subnet
* Private subnet
* AKS cluster
* System node pool
* Worker node pool
* Supporting Azure resources
* Managed identities
* Terraform state infrastructure

---

## Useful Terraform Commands

## Format Terraform files

```bash
terraform fmt -recursive
```

## Validate Terraform configuration

```bash
terraform validate
```

## Display the execution plan

```bash
terraform plan
```

## Apply the infrastructure

```bash
terraform apply
```

## Display Terraform outputs

```bash
terraform output
```

## Display sensitive outputs

```bash
terraform output -raw aks_kube_config
```

Use caution when displaying sensitive Terraform outputs because the Kubernetes configuration contains credentials.

## Show Terraform state

```bash
terraform state list
```

## Refresh and display state

```bash
terraform refresh
```

## Destroy the infrastructure

```bash
terraform destroy
```

---

## Connect to the AKS Cluster

After Terraform successfully creates the AKS cluster, retrieve the Kubernetes credentials:

```bash
az aks get-credentials \
  --resource-group pumej-aks-rg \
  --name pumej-aks \
  --overwrite-existing
```

This updates your local Kubernetes configuration:

```text
~/.kube/config
```

---

## Verify the Kubernetes Context

Display all configured Kubernetes contexts:

```bash
kubectl config get-contexts
```

Display the currently selected context:

```bash
kubectl config current-context
```

The AKS context should now be selected.

---

## Verify the AKS Cluster

Check cluster information:

```bash
kubectl cluster-info
```

Check the nodes:

```bash
kubectl get nodes
```

Example:

```text
NAME                                STATUS   ROLES
aks-system-xxxxxxxx-vmss000000     Ready    <none>
aks-system-xxxxxxxx-vmss000001     Ready    <none>
aks-worker-xxxxxxxx-vmss000000     Ready    <none>
aks-worker-xxxxxxxx-vmss000001     Ready    <none>
```

Check all Kubernetes system pods:

```bash
kubectl get pods -A
```

Check the namespaces:

```bash
kubectl get namespaces
```

---

## Azure AKS Commands

List AKS clusters:

```bash
az aks list -o table
```

Show information about the AKS cluster:

```bash
az aks show \
  --resource-group pumej-aks-rg \
  --name pumej-aks
```

Get the Kubernetes version:

```bash
az aks show \
  --resource-group pumej-aks-rg \
  --name pumej-aks \
  --query kubernetesVersion \
  -o tsv
```

List AKS node pools:

```bash
az aks nodepool list \
  --resource-group pumej-aks-rg \
  --cluster-name pumej-aks \
  -o table
```

---

## Switching Between Kubernetes Clusters

If you already have another Kubernetes cluster configured in your local kubeconfig, `az aks get-credentials` adds the AKS context rather than replacing the existing configuration.

View all contexts:

```bash
kubectl config get-contexts
```

View the current context:

```bash
kubectl config current-context
```

Switch to the AKS cluster:

```bash
kubectl config use-context <AKS_CONTEXT>
```

Switch back to your previous Kubernetes cluster:

```bash
kubectl config use-context kubernetes-admin@kubernetes
```

For example:

```bash
kubectl config use-context kubernetes-admin@kubernetes
```

---

## Why a VNet Is Required for AKS

Azure Kubernetes Service uses an Azure Virtual Network to provide networking for the Kubernetes nodes and workloads.

## Network Isolation

The VNet provides network-level isolation for the AKS infrastructure.

It defines the IP address space in which the Kubernetes nodes and supporting resources operate.

Example:

```text
10.0.0.0/16
```

---

## Subnet Placement

The AKS nodes are placed inside an Azure subnet.

Example:

```text
VNet: 10.0.0.0/16

Private subnet:
10.0.2.0/24
```

The AKS node pools use this subnet.

---

## Routing and Connectivity

The Azure VNet provides the networking foundation required for:

* Communication between Kubernetes nodes
* Pod networking
* Service networking
* Access to Azure services
* Internet connectivity
* Load balancers
* Network security controls

---

## AKS Networking

This project uses Azure CNI networking with overlay mode.

The AKS networking configuration separates:

```text
Node Network
      │
      └── Azure VNet
           │
           └── AKS Subnet

Pod Network
      │
      └── Kubernetes Pod CIDR

Service Network
      │
      └── Kubernetes Service CIDR
```

This allows the AKS cluster to maintain separate addressing for nodes, pods, and Kubernetes services.

---

## Terraform State

Terraform state is stored remotely in Azure Blob Storage.

Example:

```text
Azure Storage Account
│
└── tfstate
    │
    └── aks-cluster/
        └── terraform.tfstate
```

Remote state provides a centralized location for Terraform state and is especially useful when Terraform is executed from multiple machines or through CI/CD.

Do **not** commit the following files to Git:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
```

Add them to `.gitignore`.

Example:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
!example.tfvars
crash.log
crash.*.log
```

If `terraform.tfvars` contains subscription IDs or other environment-specific values, keep it out of source control.

---

## Git Workflow

Clone the repository:

```bash
git clone https://github.com/Mexxy-lab/Azure-eks-cluster_setup.git
```

Enter the project:

```bash
cd Azure-eks-cluster_setup
```

Check the current branch:

```bash
git branch
```

Pull the latest changes:

```bash
git pull
```

After making Terraform changes:

```bash
terraform fmt -recursive
terraform validate
terraform plan
```

Commit the changes:

```bash
git add .
git commit -m "Update Azure AKS infrastructure"
```

Push the changes:

```bash
git push
```

---

## Destroy the Environment

To remove all infrastructure managed by Terraform:

```bash
terraform destroy
```

Review the resources Terraform plans to delete and confirm with:

```text
yes
```

> **Warning:** `terraform destroy` will remove the AKS cluster, node pools, networking resources, and other infrastructure managed by this Terraform configuration.

The Terraform state Storage Account should generally be treated separately because deleting it removes the remote state required to manage the infrastructure.

---

## AWS EKS vs Azure AKS

The original project was based on AWS EKS.

The Azure implementation uses the following equivalent concepts:

| AWS                         | Azure                                |
| --------------------------- | ------------------------------------ |
| EKS                         | AKS                                  |
| VPC                         | VNet                                 |
| Subnet                      | Subnet                               |
| Availability Zone           | Availability Zone                    |
| EC2 Worker Nodes            | AKS VM Nodes                         |
| EKS Node Group              | AKS Node Pool                        |
| IAM                         | Azure RBAC / Managed Identity        |
| S3 Terraform Backend        | Azure Blob Storage Terraform Backend |
| AWS CLI                     | Azure CLI                            |
| `aws eks update-kubeconfig` | `az aks get-credentials`             |

---

## Basic Deployment Workflow

For future deployments, once the Azure remote backend has already been bootstrapped, the normal workflow is:

```bash
az login

az account show

cd Azure-eks-cluster_setup

terraform init

terraform fmt -recursive

terraform validate

terraform plan

terraform apply

az aks get-credentials \
  --resource-group pumej-aks-rg \
  --name pumej-aks \
  --overwrite-existing

kubectl config use-context kubernetes-admin@kubernetes

kubectl config current-context

kubectl get nodes

kubectl get pods -A
```

---

## Cleanup

To remove the AKS infrastructure:

```bash
terraform destroy
```

To verify that the AKS cluster has been removed:

```bash
az aks list -o table
```

To verify the resource group:

```bash
az group list -o table
```

---

## Summary

This project provides a modular Terraform implementation for deploying an Azure Kubernetes Service cluster.

The architecture separates infrastructure into reusable modules:

```text
Terraform
│
├── Terraform State
│   └── Azure Storage Account
│
├── VNet
│   ├── Public Subnet
│   └── Private Subnet
│
├── AKS Cluster
│   └── System Node Pool
│
└── AKS Node Group
    └── Worker Node Pool
```

## Checking actual quota

```bash
az vm list-usage \
  --location eastus \
  --query "[?contains(name.value, 'standardDSv5Family')]" \
  -o table

az vm list-usage \
  --location eastus \
  -o table

```

# Azure Landing Zone — Terraform

A modular, security-first Azure Landing Zone built entirely with Terraform, deployed through a GitHub Actions CI/CD pipeline with automated security gates.

## Architecture

```
Resource Group
└── Virtual Network (10.0.0.0/16)
    ├── Subnet 1 (10.0.1.0/24)
    │   ├── Public IP
    │   ├── Network Interface
    │   └── Linux VM
    └── Subnet 2 (10.0.2.0/24)
        ├── Public IP
        ├── Network Interface
        └── Linux VM
```

## What this deploys

- Resource Group
- Virtual Network with 2 subnets
- 2 Public IPs
- Network Interface(s)
- 2 Linux Virtual Machines (`azurerm_linux_virtual_machine`, provisioned via `for_each` for scalable, DRY configuration)

## Security

- **No hardcoded secrets** — all sensitive values (admin credentials, etc.) are pulled from **Azure Key Vault** at runtime instead of being stored in code or `.tfvars`.
- **State file and `.terraform/` are gitignored** — never committed to version control.

## CI/CD pipeline (GitHub Actions)

Every push runs three mandatory security gates before any infrastructure changes are applied:

| Stage | Tool | Purpose |
|---|---|---|
| 1 | `tflint` | Terraform code linting & best practices |
| 2 | `tfsec` | Static security scanning for misconfigurations |
| 3 | `trufflehog` | Secret scanning across repo & commit history |

Only after all three pass does the pipeline proceed to `terraform plan` → `terraform apply`.

```
push → tflint → tfsec → trufflehog → terraform plan → terraform apply
```

## Repo structure

```
.
├── Environment/
│   └── dev/
│       ├── main.tf
│       ├── provider.tf
│       ├── variable.tf
│       └── terraform.tfvars
├── module/
│   ├── azurerm_resource_group/
│   ├── azurerm_virtual_network/
│   ├── azurerm_subnet/
│   ├── azurerm_public_ip/
│   ├── azurerm_storage_account/
│   └── azurerm_virtual_machine/
│       ├── main.tf
│       ├── variable.tf
│       └── data.tf
└── .gitignore
```

## Prerequisites

- Terraform >= 1.x
- Azure CLI, authenticated (`az login`)
- Azure Key Vault with required secrets provisioned
- GitHub repository secrets configured for pipeline authentication

## Usage

```bash
cd Environment/dev
terraform init
terraform plan
terraform apply
```

## Notes

This is a learning/portfolio project demonstrating Infrastructure as Code, modular Terraform design, and DevSecOps pipeline practices on Azure.

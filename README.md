# InfraTDD
This is a short example how to test-driven development with cloud infrastucture.

## Installation
Before you begin you need to install the tools below.

### Terraform
We will be using Terraform to provision cloud infrastructure from code. To install Terraform, follow [this guide](https://developer.hashicorp.com/terraform/install).

### Azure CLI
This example will provision cloud resources on Azure. To be able to use Terraform, you need [install the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli#install).

### PowerShell
We will use PowerShell to write infrastructure tests. PowerShell 7 is supported on Windows, MacOS and Linux and can be [installed from here](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3).

### Pester
Pester is a testing and mocking framework for PowerShell. You can find the installation instructions [here](https://pester.dev/docs/introduction/installation).

### Azure PowerShell
To be able to interact with Azure resources from our test code you can use the [Azure PowerShell module](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-10.4.1).

## Configuration
The terraform project requires a config.tfvars that defines the `subscription_id` and `storage_account_name`.

Example config.tfvars:
```
subscription_id      = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
storage_account_name = "azureinfratddexample"
```

## Provision website
To provision the website, run:
```
./apply.sh website
```

## Run tests
To run the infra tests, run:
```
./test.sh
```
## Perform a TDD cycle
To do both at once, run:
```
./go.sh
```

BeforeAll {
    # Include global utility functions here
    # . $PSScriptRoot/../../../utility/Utility.ps1

    # Local utility functions
    # function Get-TerraformOutputValue {
    #     param (
    #         [Parameter(Mandatory = $true)]
    #         [string] $Key
    #     )

    #     $outputs = (terraform -chdir="$PSScriptRoot/.." output)
    #     $value = (($outputs | Select-String -Pattern "^${Key} = ") -split " = ")[1]
        
    #     if (-not $value) {
    #         throw "Key '$Key' not found in Terraform outputs"
    #     }

    #     $unquotedValue = ($Value -replace """","")
    #     return $unquotedValue
    # }

    function Get-TerraformConfigValue {
        param (
            [Parameter(Mandatory = $true)]
            [string] $Key
        )
    
        $Config = (Get-Content -Path "$PSScriptRoot/../config.tfvars")
        $ConfigWithoutComments = ($config -replace '#.*$','' -replace ' ','')
        $Value = (($ConfigWithoutComments | Select-String -Pattern "^${Key}=") -split "=")[1]
        $UnquotedValue = ($Value -replace """","")
    
        return $UnquotedValue
    }
}

Describe "static website" -Tag "website" {

    BeforeAll {
        $id = Get-TerraformConfigValue -Key "storage_account_name"
        $storageAccount = Get-AzStorageAccount -Name $id -ResourceGroupName $id
        $websiteUrl = $storageAccount.PrimaryEndpoints.Web
    }

    Context "without content" {
        It "cannot serve a page" {
            { Invoke-WebRequest -Uri $websiteUrl } | Should -Throw
        }
    }

    Context "with content" {
        BeforeAll {
            # Deploy content
            $container = Get-AzStorageContainer -Name "$web" -Context $storageAccount.Context

            Set-AzStorageBlobContent -Force -File "$PSScriptRoot/web/index.html" -Container $container.Name -Blob "index.html" -Context $storageAccount.Context -Properties @{
                ContentType = "text/html"
            } 
        }

        AfterAll {
            # Remove content after test
            Remove-AzStorageBlob -Container $container.Name -Blob "index.html" -Context $storageAccount.Context
        }

        It "should serve the correct page" {
            $response = Invoke-WebRequest -Uri $websiteUrl
            $response.Content | Should -Match "Hello world!"
        }
    }
}

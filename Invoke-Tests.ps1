param (
    [string]$Tag = "*"
)

# Set the error action preference so that non-terminating errors halt script execution
$ErrorActionPreference = "Stop"

# Function to check if user is logged into Azure
function IsLoggedInToAzure {
    $context = Get-AzContext

    # Check if the context is null or if the Account property is null/empty
    if ($null -eq $context -or $null -eq $context.Account -or [string]::IsNullOrEmpty($context.Account.Id)) {
        return $false
    }

    return $true
}

# Check if user is already logged in
if (-not (IsLoggedInToAzure)) {

    # Login interactively
    Connect-AzAccount

    # Check if the system is logged in after the Connect-AzAccount
    if (-not (IsLoggedInToAzure)) {
        throw "Unable to login to Azure. Please check your credentials and try again."
    }
}

try {
    # Setup test configuration
    $container = New-PesterContainer -Path '.'

    $configuration = New-PesterConfiguration -Hashtable @{
        Run = @{
            PassThru = $true
            Container = $container
        }
        Filter = @{ 
            Tag = $Tag
        }

        TestResult = @{
            Enabled = $true
            OutputFormat = "NUnitXML"
            OutputPath = "TestResults.xml"
        }
        Output = @{
            Verbosity = "Detailed"
        }
    }

    # Run tests
    $Results = Invoke-Pester -Configuration $configuration

    # Return the number of errors
    exit $Results.FailedCount
}
catch {
    # Catch any exceptions and write the error message
    Write-Error "An error occurred: $_"
    exit 1
}

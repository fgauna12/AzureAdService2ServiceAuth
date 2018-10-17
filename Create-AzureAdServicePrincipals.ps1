function Create-AzureAdServicePrincipal {
    param(
        # Identifier URI
        [Parameter(Mandatory = $true)]
        [string]
        $IdentifierUri,
        # Service Principal Name
        [Parameter(Mandatory = $true)]
        [string]
        $ServicePrincipalName,
        # Reply URLs
        [Parameter(Mandatory = $false)]
        [string[]]
        $ReplyUrls = @("https://localhost:44305/signin-oidc")
    )
    process {
        $application = New-AzureRmADApplication `
            -DisplayName $ServicePrincipalName `
            -IdentifierUris @($IdentifierUri) `
            -ReplyUrls $ReplyUrls `
            -Verbose `
            -ErrorAction 'Stop'

        $servicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $application.ApplicationId
    }
    end {
        return $servicePrincipal;
    }
}

function Create-ClientSecret {
    param(
        # Object ID
        [Parameter(Mandatory = $true)]
        [string]
        $ApplicationId
    )
    begin {
        Add-Type -Assembly System.Web
        $password = [System.Web.Security.Membership]::GeneratePassword(16,3)

        Write-Host "Password will only be shown once: $password"
    }
    process {
        $securePassword = ConvertTo-SecureString -Force -AsPlainText -String $password        
        $endDate = (Get-Date).AddYears(1)
        New-AzureRmADAppCredential -ApplicationId $ApplicationId -Password $securePassword -EndDate $endDate
    }
}

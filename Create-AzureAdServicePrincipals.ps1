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
        New-AzureRmADApplication `
            -DisplayName $ServicePrincipalName `
            -IdentifierUris @("https://equifax.com/") `
            -ReplyUrls $ReplyUrls `
            -Verbose
    }
}


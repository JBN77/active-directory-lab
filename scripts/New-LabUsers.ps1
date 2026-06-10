<#
.SYNOPSIS
Creates Active Directory lab users from a first-name/last-name text file.

.DESCRIPTION
Each input line should contain a first name and last name separated by whitespace.
The script creates users in a target OU with a generated username pattern:
first initial + last name.

.EXAMPLE
.\New-LabUsers.ps1 -NamesPath .\sample-names.txt -TargetOu "OU=_USERS,DC=mydomain,DC=com"
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path -LiteralPath $_ })]
    [string]$NamesPath,

    [Parameter(Mandatory)]
    [string]$TargetOu,

    [Parameter()]
    [string]$DefaultPassword = "ChangeMe-Password1!",

    [Parameter()]
    [switch]$ForcePasswordChangeAtLogon
)

Import-Module ActiveDirectory

$securePassword = ConvertTo-SecureString $DefaultPassword -AsPlainText -Force
$names = Get-Content -LiteralPath $NamesPath | Where-Object { $_.Trim().Length -gt 0 }

foreach ($name in $names) {
    $parts = $name.Trim() -split "\s+"

    if ($parts.Count -lt 2) {
        Write-Warning "Skipping '$name'. Expected format: FirstName LastName"
        continue
    }

    $firstName = $parts[0]
    $lastName = $parts[-1]
    $username = ("{0}{1}" -f $firstName.Substring(0, 1), $lastName).ToLower()

    $userParams = @{
        AccountPassword        = $securePassword
        GivenName              = $firstName
        Surname                = $lastName
        DisplayName            = "$firstName $lastName"
        Name                   = $username
        SamAccountName         = $username
        UserPrincipalName      = "$username@mydomain.com"
        EmployeeID             = $username
        Path                   = $TargetOu
        Enabled                = $true
        ChangePasswordAtLogon  = [bool]$ForcePasswordChangeAtLogon
    }

    if ($PSCmdlet.ShouldProcess($username, "Create Active Directory user")) {
        New-ADUser @userParams
        Write-Host "Created user: $username" -ForegroundColor Cyan
    }
}

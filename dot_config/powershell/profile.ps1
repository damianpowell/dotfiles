$env:SHLVL = [int]$env:SHLVL + 1

iex (&starship init powershell)

Import-Module Terminal-Icons
Import-Module PSReadLine -MinimumVersion 2.2.5
Import-Module z

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

function Get-AvbValue {
    param([string] $Path = $null)
    $uri = 'http://sa-ultralite-avb.local/datastore/'
    Invoke-RestMethod -Method Get -Uri ($uri + $Path)
}

function Set-AvbValue {
    param([string] $Path = $null, [object] $Value = $null, [switch] $WhatIf)
    $uri = 'http://sa-ultralite-avb.local/datastore/'
    if ($null -eq $Path)  { throw "Path must be specified when setting a value" }
    if ($null -eq $Value) { throw "Value must be specified when setting a value" }
    $json = if ($Value -is [hashtable]) { ConvertTo-Json $Value -Depth 99 } else { ConvertTo-Json @{ value = $Value } -Depth 99 }
    Invoke-RestMethod -Method Patch -Uri ($uri + $Path) -Form @{ json = $json }
}

function Get-FullName {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $True)]
	$Value
    )
    process {
	if ($Value -is [Microsoft.PowerShell.Commands.MatchInfo]) { $Value.Path } else { $Value.FullName }
    }
}
Set-Alias gfn Get-FullName

# PowerShell completion for brew
$(/opt/homebrew/bin/brew shellenv) | Invoke-Expression

Set-Alias vim nvim

Enable-TransientPrompt

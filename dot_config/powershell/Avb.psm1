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

Export-Function *-*


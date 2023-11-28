$env:SHLVL = [int]$env:SHLVL + 1

iex (&starship init powershell)
Enable-TransientPrompt

Import-Module PSReadLine -MinimumVersion 2.2.5
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

Import-Module Terminal-Icons
Import-Module z

function Add-PathItem {
    param([string]$Path)
    pathParts = $env:PATH -split ';'
    $sep = $env:PATH.Contains(';') ? ';' : ':'
    if ($pathParts -notcontains $Path) {
        $env:PATH += $sep + $Path
    }
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

#
# Set up Vim.
#
$programFiles = [Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFiles)
$vimPath = Convert-Path $programFiles/Vim/vim90
Add-PathItem $vimPath
Set-Alias vi vim
if (Get-Command -EA SilentlyContinue nvim) {
    Set-Alias vim nvim
}


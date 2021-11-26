#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Set-VSCodeVenvOption'
        'Get-VSCodeVenvOption'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}





class VSCodeVenvOption {
    [string]$DefaultBinPath
    [string]$DefaultDataDir
    [string]$DefaultExtensionDir
}

function Set-VSCodeVenvOption {
    <#
    .synopsis
        quick hack: save metadat

    future could be one command
        venv-config <set|get> [key] [value]

    #>
    [cmdletbinding()]
    param()
    throw 'WIP'
}
function Get-VSCodeVenvOption {
    <#
    .synopsis
        quick hack: save metadat
    #>
    [cmdletbinding()]
    param()
    throw 'WIP'
    'me first'
}

Write-Warning 'need: abstract, minimal, nested config class for arbitrary data to json store'

if (! $experimentToExport) {
    # ...

    # ls .
}
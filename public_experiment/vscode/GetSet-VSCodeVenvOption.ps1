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
    #>
    [cmdletbinding()]
    param()
}
function Get-VSCodeVenvOption {
    <#
    .synopsis
        quick hack: save metadat
    #>
    [cmdletbinding()]
    param()
}

Write-Warning 'need: abstract, minimal, nested config class for arbitrary data to json store'

if (! $experimentToExport) {
    # ...
}
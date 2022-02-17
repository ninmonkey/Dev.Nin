#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-RandomBoolean'
    )
    $experimentToExport.alias += @(
        'random->Bool' # 'Get-RandomBoolean'
        'randBool' # 'Get-RandomBoolean'

    )
}

function Get-RandomBoolean {
    <#
    .synopsis
        Return a random Bool. That's it.
    #>
    [Alias('Random->Bool', 'randBool')]
    [OutputType([System.Boolean])]
    [cmdletbinding()]
    param(

    )
    1 -eq (Microsoft.PowerShell.Utility\Get-Random -Minimum 1 -Maximum 3)
}

if (! $experimentToExport) {
    # ...
}

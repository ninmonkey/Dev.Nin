#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-BatHelp'
    )
    $experimentToExport.alias += @(
        'Bat->Help'
    )
}


function Get-BatHelp {
    <#
    .synopsis
        sugar for better Default args for viewing help files
    .notes

    .example
    #>

    [Alias('Bat->Help')]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$PwshHelpName
    )
    Get-Help $PwshHelpName -Full
    | bat -p -l man
}

if (! $experimentToExport) {
    # ...
}


#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Find-AliasForCommand'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}


function Find-AliasForCommand {
    <#
    .synopsis
        minimal Get aliases that point to this command
    .example
        Find-AliasForCommand Get-TimeStuff
    #>
    param(
        [Alias('Name')]
        [Parameter(Mandatory, Position = 0)]
        [string]$CommandName
    )
    Get-Alias -Definition $CommandName | ForEach-Object Name
    | Sort-Object -Unique
}


if (! $experimentToExport) {
    # ...
    Find-AliasForCommand Get-TimeStuff
}
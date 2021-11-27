#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-HelpExample'
    )
    $experimentToExport.alias += @(
        'HelpEx'
    )
}

function Get-HelpExample {
    <#
    sugar for get-help examples
    #>
    [alias('helpEx')]
    param(
        # alias/command to lookup help on
        [Parameter(Mandatory, Position = 0, ValueFromPipeline )]
        [string]$CommandName
    )
    process {
        Get-Command $CommandName | help -Examples
    }
}

if (! $experimentToExport) {
    # ...
    Get-Command 'str' | Get-HelpExample
}
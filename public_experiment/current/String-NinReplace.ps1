#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'String-NinReplace'
    )
    $experimentToExport.alias += @(
        'StrReplace'
        '-Replace'
    )
}

function String-NinReplace {
    <#
    .synopsis
        sugar for "$x | %{ $_ -replace $regex, $replacement }"
    .description
       .
    .example
          .
    .outputs
          [string
    .link
        Irregular
    .link
        Dev.Nin\Match-String
    .link
        Dev.Nin\Split-String
    .link
        Dev.Nin\Where-MatchAnyText
    .link
        Ninmonkey.Console\ConvertFrom-NumberedFilepath

    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    begin {
        throw 'finish me, make sure to all null piping'
    }
    process {

    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
}

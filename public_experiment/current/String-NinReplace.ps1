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
    [Alias('StrReplace', '-replace')]
    [CmdletBinding()]
    param(
        # source text
        [parameter(Mandatory, ValueFromPipeline)]
        [string]$InputText,

        # regex pattern
        [Alias('Regex')]
        [parameter(Mandatory, Position = 0)]
        [string]$Pattern,


        [parameter(Position = 1)]
        [string]$ReplacementString = [string]::Empty
    )

    begin {

    }
    process {
        $InputText | ForEach-Object { $_ -replace $Pattern, $ReplacementString }
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
}

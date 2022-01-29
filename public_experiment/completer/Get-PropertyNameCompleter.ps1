#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-PropertyNameCompleter'
    )
    $experimentToExport.alias += @(
        'Completions->PropName' # Get-PropertyNameCompleter
    )
}


function Get-PropertyNameCompleter {
    <#
    .synopsis
        Stuff
    .description
       .
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias('Completions->PropName')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter( Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    begin {
    }
    process {
        $InputObject | IterProp
        | ForEach-Object Name | Sort-Object -Unique
    }
    end {
    }
}

# Write-Error 'nyi paste'


if (! $experimentToExport) {
    # ...
}

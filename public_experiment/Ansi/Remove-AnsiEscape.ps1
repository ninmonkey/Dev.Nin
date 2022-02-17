#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Remove-AnsiEscape'

    )
    $experimentToExport.alias += @(
        'StripAnsi' # 'Remove-AnsiEscape'
    )
}

function Remove-AnsiEscape {
    <#
    .synopsis
        remove ansi colors (or all control sequences)
    #>

    [Alias('StripAnsi')]
    [cmdletbinding()]
    param(
        [Alias('Text')]
        [AllowNull()]
        [AllowEmptyString()]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$InputObject,

        # misc label
        [alias('All')]
        [switch]$StripEverything
    )
    begin {
        # Regex from Jaykul
        $Regex = @{
            StripColor = '\u001B.*?m'
            StripAll   = '\u001B.*?\p{L}'
        }
        # I use that for stripping escape sequences so I can measure string length
        # But it removes everything
        # if you wanted just color stuff, you might put m instead of \p{L}

    }
    process {
        if ($null -eq $InputObject) {
            return
        }
        if ($StripEverything) {
            $InputObject -replace $Regex.StripAll, ''
        } else {
            $InputObject -replace $Regex.StripColor, ''
        }

    }
}


if (! $experimentToExport) {
    # ...
}

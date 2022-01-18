#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'F'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function Test-IsRegex {
    param(
        [Parameter(ValueFromPipeline, Position = 0)]
        [string]$inputText
    )
    process {
        $MaybeRe = $inputText
        [pscustomobject]@{
            Regex   = $MaybeRe
            IsRegex = $MaybeRe -ne [regex]::Escape($MaybeRe)
        }
    }
}

if (! $experimentToExport) {
    $null, '1', '/', '', '234', '*' | ForEach-Object {
        $re = $_
        [pscustomobject]@{
            Regex   = $re
            IsRegex = $re -ne [regex]::Escape($re)
        }
    }
    # ...
}

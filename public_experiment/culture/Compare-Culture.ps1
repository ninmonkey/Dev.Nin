#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Compare-Culture'
    )
    $experimentToExport.alias += @(

    )
}

function Compare-Culture {
    <#
    .synopsis
        create a quick diff comparison of two culture objects, using code --diff on json
    .notes
        .
    .example
        PS> Compare-Culture 'en-us' 'en-gb'
    #>
    [cmdletbinding()]
    param(

        # First object to compare
        # I didn't use object, because calling Get-Culture with [CultureInfo] instead of
        # a string returns the same result
        [parameter(Mandatory, Position = 0)]
        [string]$InputCulture1,

        # second to compare
        [parameter(Mandatory, Position = 1)]
        [string]$InputCulture2
    )
    begin {
    }
    process {
        $cult1 = Get-Culture -Name $InputCulture1 -ea stop
        $cult2 = Get-Culture -Name $InputCulture2 -ea stop

        Assert-NotNull $cult1
        Assert-NotNull $cult2

        $PathDest1 = 'temp:\cult1.json'
        $PathDest2 = 'temp:\cult2.json'

        $cult1 | dump | Set-Content $PathDest1
        $cult2 | dump | Set-Content $PathDest2

        $PathDest1 = Get-Item $PathDest1
        $PathDest2 = Get-Item $PathDest2

        h1 'wrote'
        $PathDest1, $PathDest2
        | str ul -DoubleQuote
        @'
        run: -> & $binCode @('--diff', $PathDest1, $pathDest2)
'@

    }
    end {
    }
}

if (! $experimentToExport) {
    
    # ...
}
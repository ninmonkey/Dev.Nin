#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

        'ConvertTo-PqDocString'
        'Format-Unindent'
    )
    $experimentToExport.alias += @(

    )
}

function ConvertTo-PqDocString {
    param( [string[]]$InputText )
    $InputText -join "`n" -replace '"', '""'
}


function Format-Unindent {
    [cmdletbinding()]
    param( [string[]]$InputText, [int]$Depth)
    $replaceRegex = @(
        '^\ ' + '{',
        ' ' * $Depth * 4
        #$Depth * 4
        '}'
    ) | Join-String


    $replaceRegex = '^\ {{{0}}}' -f @(4 * $Depth)
    Write-Debug $replaceRegex

    $InputText -join "`n" -split '\r?\n' -replace $replaceRegex, ''

}


if (! $experimentToExport) {
    ConvertTo-PqDocString -InputText $c
    Format-Unindent -InputText $c -Depth 2 -debug

}

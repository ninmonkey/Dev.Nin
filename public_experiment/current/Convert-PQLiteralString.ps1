#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

        'Convert-PQLiteralString'

    )
    $experimentToExport.alias += @(

    )
}

function Convert-PQLiteralString {
    param( [string[]]$InputText )
    $InputText -join "`n" -replace '"', '""'
}



if (! $experimentToExport) {
    Convert-PQLiteralString -InputText $c
}

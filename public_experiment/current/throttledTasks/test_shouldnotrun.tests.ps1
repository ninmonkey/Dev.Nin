#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

    )
    $experimentToExport.alias += @(

    )
}



if (! $experimentToExport) {
    # test the filter doesn't pick this up
    throw "Unexpected $PSCommandPath"
    # ...
}

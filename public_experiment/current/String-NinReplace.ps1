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

if (! $experimentToExport) {
    # ...
}

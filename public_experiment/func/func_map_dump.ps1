#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_mapStripNSPrefix'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}
function _mapStripNSPrefix {
    # from 1-liner func mapping examples
    process { $_ -replace 'System\.', '' }
}



if (! $experimentToExport) {
    # ...
}

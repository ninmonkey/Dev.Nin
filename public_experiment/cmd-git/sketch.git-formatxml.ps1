#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

    )
    $experimentToExport.alias += @(

    )
    $experimentToExport.update_typeDataScriptBlock += @(
        # no formatdata

    )
    # $experimentToExport.'function'                   = @()
    # $experimentToExport.'alias'                      = @()
    # $experimentToExport.'cmdlet'                     = @()
    # $experimentToExport.'variable'                   = @()
    # $experimentToExport.'meta'                       = @()
    # $experimentToExport.'experimentFuncMetadata'     = @()
}

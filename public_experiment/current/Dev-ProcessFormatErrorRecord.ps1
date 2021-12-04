#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Dev-ProcessFormatErrorRecord'
    )
    $experimentToExport.alias += @(
        'er' # to profile
    )
}

function Dev-ProcessFormatErrorRecord {
    <#
    Wrapper to '$error' indices for piping with other commands
    #>
    [Alias('er')]
    param( $Slice)
    $target = $global:error
    if ($Slice -ge $target.length) {
        return
    }
    $target[$Slice]
}
#$error[2]  }}| e -ErrorRecord)

if (! $experimentToExport) {
    # ...
}

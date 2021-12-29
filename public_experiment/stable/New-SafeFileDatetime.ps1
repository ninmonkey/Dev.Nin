#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-SafeFileDatetime'
    )
    $experimentToExport.alias += @(
        'Time->SafeFilename'
    )
}

function New-SafeFileDatetime {
    <#
     .synopsis
         safe directory name, a little more human readable than filetime
     .description
         based on: universal sortable "u"
         precision is per-seconds
     .example
         PS> New-SafeFileDatetime
         # output 2021-04-08_13-29-03Z

     .example
         # converts
             2021-02-23 12:24:57Z

         # to
             2021-02-23_12-25-05Z

         PS> $now.ToFileTime()
         132585782972158069
     #>
    param(
        # Optional datetime, if current time is not wanted
        [Parameter(ValueFromPipeline, position = 0)]
        [datetime]$InputObject

    )
    process {
        $InputObject ??= Get-Date
        $InputObject.tostring('u') -replace ' ', '_' -replace ':', '-'
    }
}



if (! $experimentToExport) {
    # ...
}

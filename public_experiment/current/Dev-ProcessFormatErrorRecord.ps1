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
    begin {

        function _collect-FormatErrorStacktrace {
            $Error.GetEnumerator() | ForEach-Object { $errIndex = 0 } {
                $curError = $_
                "`n`n==== error[$errIndex]`n"
                "`n== Exception`n"
                $curError | e | ForEach-Object Tostring
                "`n`n--`n"
                "`n== ErrorRecord`n"
                $curError | e -ErrorRecord | ForEach-Object Tostring
                "`n`n--`n"
                "`n== StackTrace`n"
    ($_.StackTrace)?.ToString() ?? "[`u{2400}]"
            }
        }

        # _collect-FormatErrorStacktrace

    }
    process {
        $target = $global:error
        if ($Slice -ge $target.length) {
            return
        }
        $target[$Slice]
        #$error[2]  }}| e -ErrorRecord)
    }
    end {
    }
}


if (! $experimentToExport) {
    # ...
}

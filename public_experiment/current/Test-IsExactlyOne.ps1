#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Test-IsExactlyOne'
    )
    $experimentToExport.alias += @(
        '?IsExactlyOne'
        'IsExactlyOne'

    )
}

function Test-IsExactlyOne {
    <#
        .SYNOPSIS
            is this exactly one result ?
        .notes
            future: Move to /ninmonkey/Testning


        #>
    [Alias(
        'IsExactlyOne',
        '?IsExactlyOne'
    )]
    [OutputType('System.boolean')]
    [cmdletbinding()]
    param (
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]
        [Parameter(Position = 0, ValueFromPipeline)]
        $InputObject
        # [Parameter()]
        # [switch]$NoEnumerate
    )

    # enumerate arrays or treat array as one param ?
    # or that doesn't make sense in this context
    # )
    begin {
        # $finalValue = $false # to prevent nulls
        [list[object]]$items = @()
    }

    process {
        if ($InputObject.count -gt 1) {
            return
        }

        if ($null -eq $InputObject) {
            return
        } else {
            $items.Add( $InputObject ) | Out-Null
            return
        }
    }
    end {
        $items.count -eq 1
    }
}



if (! $experimentToExport) {
    # ...
}

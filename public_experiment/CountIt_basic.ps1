using namespace System.Collections.Generic
#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Measure-ObjectCount'
        # ''
    )
    $experimentToExport.alias += @(
        'Count', 'Len'
        #'Len_basic' # 'Measure-ObjectCount

    )
}

function Measure-ObjectCount {
    <#
    .synopsis
        Simple. Counts items. Shortcut for the cli, simplifed version of Dev.Nin\Measure-ObjectCount
    .description
       This is for cases where you had to use
       ... | Measure-Object | % Count | ...
    .notes
        -
    .example
        🐒> ls . | Count
    .outputs
          [int]
    .link
        Dev.Nin\Measure-ObjectCount
    .link
        Dev.Nin\Measure-ObjectCount

    #>

    [alias( 'Count', 'Len')]
    [CmdletBinding()]
    param(
        #Input from the pipeline
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        # # instead write count to write-information, pipe object normally
        # [Parameter()][switch]$PassThru,

        # # do not count 'Blank' values
        [Alias('IgnoreNull')]
        [Parameter()][switch]$IgnoreBlank

    )
    begin {
        [hashtalbe]$Config = @{
            Experimental_AutoEnableEnableWIPref = $false
        }
        $original_infaPref = $InformationPreference

        if ($PassThru -or $Label) {
            if ($Config['Experimental_AutoEnableEnableWIPref']) {
                $InformationPreference = 'Continue'
            }
        }
        $objectList = [List[object]]::new() # maybe redundant now?
        switch ($PassThru) {
            $true {

            }
            default {
                [int]$_totalItems = 0
            }

        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {
        switch ($PassThru) {
            $true {
                $_totalItems++
                $InputObject

                if (! $Config.PrintOnEveryObject) {
                    return
                }
                $msg = '{0}: {1}' -f @(
                    $Label ?? 'len'
                    $objectList.Count
                )

                if ($Config.PrintNewElementType) {
                    $msg += ' [{0}]' -f @(
                        $InputObject
                        | Dev.Nin\Get-WhatIsShortTypeName
                        | write-color 'gray45'
                    )

                }
                $msg | Write-Information

            }
            default {
                $InputObject | ForEach-Object {
                    $objectList.Add( $_ )
                }
            }

        }

    }
    end {
        if ($PassThru -or $Label) {
            # can't assume reaches end, or can I reset value on IDisposal/destructor
            if ($Config['Experimental_AutoEnableEnableWIPref']) {
                $InformationPreference = $original_infaPref
            }
        }
        switch ($PassThru) {
            $true {
                'Len: {0}' -f $_totalItems
                #   | Write-Information
              | Write-Information
                return
            }
            default {
                if ( $IgnoreBlank) {
                    $objectList
                    | Dev.Nin\Where-IsNotBlank
                    | Measure-Object | ForEach-Object Count
                    return
                }
                $objectList
                | Measure-Object | ForEach-Object Count
            }

        }

    }
}


if (! $experimentToExport) {
    3, 4.5, (Get-Item .) , (Get-Date), $null, 50 | len -PassThru -InformationAction Ignore
    | Out-Null
    # ...
}

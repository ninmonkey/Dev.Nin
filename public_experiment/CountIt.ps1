using namespace System.Collections.Generic
#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Measure-ObjectCount'
        # ''
    )
    $experimentToExport.alias += @(
        'Len'
        # ''
    )
}


# no longer applies?  # $StringModule_DontInjectJoinString = $true # https://github.com/FriedrichWeinmann/string/#join-string-and-powershell-core




function Measure-ObjectCount {
    <#
    .synopsis
        ~~Simple~~. Counts items. Shortcut for the cli. Crazy variant of Dev.Nin\Measure-ObjectCount_basic
    .description
       This is for cases where you had to use
       ... | Measure-Object | % Count | ...
    .notes
        Future: maybe parameter to measure line vs byte vs enumerate
    .example
        🐒> ls . | Count
    .outputs
          [int]
    .link
        Dev.Nin\Measure-ObjectCount
    .link
        Dev.Nin\Measure-ObjectCount_basic
    #>

    [alias( 'CountIt', 'Count', 'Len')]
    [CmdletBinding()]
    param(
        #Input from the pipeline
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        # instead write count to write-information, pipe object normally
        [Parameter()][switch]$PassThru,

        # do not count 'Blank' values
        [Alias('IgnoreNull')]
        [Parameter()][switch]$IgnoreBlank,

        # optional label using infa output
        [Parameter()][string]$Label,


        # extra options
        [Parameter()][hashtable]$Options


    )
    begin {
        [hashtable]$Config = @{
            PrintOnEveryObject                  = $false
            PrintNewElementType                 = $false
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
                $objectList.AddRange( $InputObject )
                # $InputObject | ForEach-Object {
                #     $objectList.Add( $_ )
                # }
            }

        }

    }
    end {

        $itemCount = if ( $IgnoreBlank) {
            $objectList
            | Dev.Nin\Where-IsNotBlank
            | Measure-Object | ForEach-Object Count
            return
        } else {
            $itemCount = $objectList
            | Measure-Object | ForEach-Object Count
        }

        return

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
        # switch ($PassThru) {
        #     $true {
        #         'Len: {0}' -f $_totalItems
        #         #   | Write-Information
        #       | Write-Information
        #         return
        #     }
        #     default {
        #         if ( $IgnoreBlank) {
        #             $objectList
        #             | Dev.Nin\Where-IsNotBlank
        #             | Measure-Object | ForEach-Object Count
        #             return
        #         }
        #         $objectList
        #         | Measure-Object | ForEach-Object Count
        #     }

        # }

    }
}


if (! $experimentToExport) {
    if ($true) {
        h1 'pass'

        0..3 | len -PassThru
        | Join-String -sep ', ' | write-color 'orange'

        h1 'none'

        0..3 | len
        | Join-String -sep ', ' | write-color 'orange'
        h1 'pass -Infa'

        0..3 | len -PassThru -infa continue
        | Join-String -sep ', ' | write-color 'orange'

        h1 'none -Infa'

        0..3 | len -infa continue
        | Join-String -sep ', ' | write-color 'orange'

        hr -fg magenta

        'now:
            $Options @{}

            [ ] print on every add
            [ ] print current count, on every add
        '
    }

    if ($false) {
        3, 4.5, (Get-Item .) , (Get-Date), $null, 50 | len -PassThru -InformationAction Ignore
        | Out-Null
        # ...


        0..3 | len -PassThru | Join-String -sep ', ' | write-color
        | len -label 'fin' -PassThru
    }
}

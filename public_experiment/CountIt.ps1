using namespace System.Collections.Generic
#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'dev.Measure-ObjectCount'
        # ''
    )
    $experimentToExport.alias += @(
        'dev.Len'
        # ''
    )
}


# no longer applies?  # $StringModule_DontInjectJoinString = $true # https://github.com/FriedrichWeinmann/string/#join-string-and-powershell-core




function dev.Measure-ObjectCount {
    <#
    .synopsis
        ~~Simple~~. Counts items. Shortcut for the cli. Crazy version of variant of Dev.Nin\Measure-ObjectCount
    .description
       This is for cases where you had to use
       ... | Measure-Object | % Count | ...


        ## Mode 1: count

            - outputs length as an int, no objects

            ls . * | len

        ## mode 2: -PassThru

            - object using normal output stream
            - length printed as write-information (to not affect user)

            ls . * | len -PassThru | ft Name, LastWriteTIme


        ## mode 3: don't finish, display


            ls . * | len -PassThru -Options @{PrintOnEveryObject=$true} | ft Name, LastWriteTIme

            0..4 | Len -PassThru -InformationAction Continue -Options @{PrintOnEveryObject=$true} -Label 'increment'


    .notes
        Future: maybe parameter to measure line vs byte vs enumerate
    .example
        🐒> ls . | Count
    .outputs
          [int]
    .link
        Ninmonkey.Console\Measure-ObjectCount
    .link
        Dev.Nin\dev.Measure-ObjectCount
    #>

    [alias( 'dev.Len')]
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
            PrintOnEveryIteration                 = $false
            OutputMode                            = $PassThru ? 'OnlyInt' : 'WithInformation'
            'Experimental_AutoEnableEnableWIPref' = $true
            'Label'                               = $Label ?? 'Len'
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
        $original_infaPref = $InformationPreference
        $objectList = [List[object]]::new()


        if ($PassThru -or $Label) {
            if ($Config['Experimental_AutoEnableEnableWIPref']) {
                $InformationPreference = 'Continue'
            }
        }
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
                    $Config.Label
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
            | Microsoft.PowerShell.Utility\Measure-Object | ForEach-Object Count
            return
        } else {
            $objectList
            | Microsoft.PowerShell.Utility\Measure-Object | ForEach-Object Count
        }
        # Wait-Debugger


        # $z = 'noop'
        if ($PassThru -or $Label) {
            # can't assume reaches end, or can I reset value on IDisposal/destructor
            if ($Config['Experimental_AutoEnableEnableWIPref']) {
                $InformationPreference = 'continue'
                # $InformationPreference = $original_infaPref
            }
            # $z = 'noop'

        }
        'Infa is on' | write-color 'magenta' | Write-Information
        switch ($PassThru) {
            $true {
                '{0}: {1}' -f @(
                    $Label
                    $_totalItems
                )
                #   | Write-Information
              | Write-Information
                # $z = 'noop'
                return
            }
            default {
                if ( $IgnoreBlank) {
                    $objectList
                    | Dev.Nin\Where-IsNotBlank
                    | Microsoft.PowerShell.Utility\Measure-Object | ForEach-Object Count
                    # $z = 'noop'
                    return
                }
                $objectList
                | Microsoft.PowerShell.Utility\Measure-Object | ForEach-Object Count
                # $z = 'noop'

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
        #             | Microsoft.PowerShell.Utility\Measure-Object | ForEach-Object Count
        #             return
        #         }
        #         $objectList
        #         | Microsoft.PowerShell.Utility\Measure-Object | ForEach-Object Count
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

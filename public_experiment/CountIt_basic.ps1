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
        future:
            - Parameter <condition> that works how Sort-Object's -Property param works
    .example
        🐒> ls . | Count # how many files?
        4

    .outputs
          [int]
    .link
        Dev.Nin\Where-IsNotBlank
    .link
        Dev.Nin\Measure-ObjectCount

    #>

    [alias( 'Count', 'Len')]
    [CmdletBinding()]
    param(
        #Input from the pipeline
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        # do not count 'Blank' values
        [Alias('IgnoreNull')]
        [Parameter()][switch]$IgnoreBlank

    )
    begin {
        $objectList = [List[object]]::new()
    }
    process {
        $objectList.AddRange( $InputObject )

    }
    end {
        if ($IgnoreBlank) {
            $objectList
            | Dev.Nin\Where-IsNotBlank
            | Measure-Object | ForEach-Object Count
        } else {
            $objectList
            | Measure-Object | ForEach-Object Count
        }
    }
}

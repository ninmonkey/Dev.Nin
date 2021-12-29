using namespace System.Collections.Generic

# $StringModule_DontInjectJoinString = $true # https://github.com/FriedrichWeinmann/string/#join-string-and-powershell-core

$experimentToExport.function += @(
    'Measure-ObjectCount'
)
$experimentToExport.alias += @(
    'Len'
)
function Measure-ObjectCount {
    <#
    .synopsis
        Simple. Counts items. Shortcut for the cli
    .description
       This is for cases where you had to use
       ... | Measure-Object | % Count | ...
    .notes
        Future: maybe parameter to measure line vs byte vs enumerate
    .example
        🐒> ls . | Count
    .outputs
          [int]
    #>

    [alias( 'CountIt', 'Count', 'Len')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        #Input from the pipeline
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        # do not count 'Blank' values
        [Alias('IgnoreNull')]
        [switch]$IgnoreBlank
    )
    begin {
        $objectList = [List[object]]::new()
    }
    process {
        $InputObject | ForEach-Object {
            $objectList.Add( $_ )
        }
    }
    end {
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

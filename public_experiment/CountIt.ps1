# $StringModule_DontInjectJoinString = $true # https://github.com/FriedrichWeinmann/string/#join-string-and-powershell-core

$experimentToExport.function += @(
    'Measure-ObjectCount'
)
$experimentToExport.alias += @(
    'CountIt'
    'Count'
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
        [object[]]$InputObject
    )
    begin {
        $objectList = [list[object]]::new()
    }
    process {
        $InputObject | ForEach-Object {
            $objectList.Add( $_ )
        }
    }
    end {
        try {
            $objectList | Measure-Object | ForEach-Object Count
        }
        catch {
            $PSCmdlet.WriteError( $_ )
        }
    }
}

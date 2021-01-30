
function Where-FzfSelectObject {
    <#
    .SYNOPSIS
    a 'Where-Object' the user selects on run time

    .DESCRIPTION
    Like piping to Out-GridView, saving the selection, then applying the filter on the original pipeline

    .EXAMPLE

    .NOTES
    future:
        param: -Cached
            - [ ] multiple re-runs of the command only prompt on the first run

        - [ ] DynamicCompleter for 'ProperyName'
    #>

    param(
        # InputPipe
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # Property to filter by
        [Parameter(Mandatory, Position = 0)]
        [string]$PropertyName
    )

    begin {
        $listObjects = [list[object]]::new()
    }
    process {
        $listObjects.Add( $InputObject )
    }
    end {}
}

if ($false -and 'filterGcm by Source') {
    Get-Command -Noun '*hist*' -ov 'ovGcm'

    # now do Get-UserPropertyNames
    $ovGcm | Sort-Object Source -Unique | ForEach-Object Source | Sort-Object
    | Out-Fzf -ov 'ovFzf'

    $fzf -join ', '  | Label 'Selection' -bef 1
}
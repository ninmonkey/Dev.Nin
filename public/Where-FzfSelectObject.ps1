using namespace system.collections.generic

function Where-FzfSelectObject {
    <#
    .SYNOPSIS
    a 'Where-Object' the user selects on run time

    .DESCRIPTION
    The difference from 'Select-NinProperty' is that Where doesn't modify the value.
    'Select-NinProperty' returns a new selection

    Like piping to Out-GridView, saving the selection, then applying the filter on the original pipeline

    .EXAMPLE

    .NOTES
    future:
        param: -Cached
            - [ ] multiple re-runs of the command only prompt on the first run

        - [ ] DynamicCompleter for 'ProperyName'
    .link
        Select-NinProperty
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
        Write-Warning 'not finished'
    }
    process {
        if ($InputObject) {
            $listObjects.Add( $InputObject )
        }
    }
    end {
        $SelectedProps = $listObjects | ForEach-Object $PropertyName | Sort-Object -Unique
        if (! $SelectedProps ) {
            Write-Error 'nothing found'
            return
        }
        if (! $SelectedProps.count -eq 0) {
            Write-Error 'nothing found'
            return
        }

        $SelectedProps | Out-Fzf -MultiSelect "Property: $PropertyName"

        $listObjects | Where-Object {
            $_.$PropertyName -in $SelectedProps
        }
    }
}

if ($false) {
    $gcm ??= Get-Command 'hist'
    $gcm | Where-FzfSelectObject Source #-ErrorAction break
    'done'
}

if ($false -and 'filterGcm by Source') {
    Get-Command -Noun '*hist*' -ov 'ovGcm'

    # now do Get-UserPropertyNames
    $ovGcm | Sort-Object Source -Unique | ForEach-Object Source | Sort-Object
    | Out-Fzf -ov 'ovFzf'

    ovFzf -join ', ' | Label 'Selection' -bef 1
}

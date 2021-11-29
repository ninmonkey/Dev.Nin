#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Group-ObjectCount'
    )
    $experimentToExport.alias += @(
        'Iter->ByCount',
        'GroupBySize'
    )
}


function Group-ObjectCount {
    <#
    .synopsis
        collects items and emits them in groups **without full listing**
    .notes
        Need a real name
    .description
        0..6 GroupByCount 3 returns:
            @(
                0..2
                3..5
                6
            )

    .example
            0..6 GroupByCount 3 returns:
            @(
                0..2
                3..5
                6
            )

          .
    .outputs
          [object[]]

    #>
    [Alias(
        'Iter->ByCount',
        'GroupBySize'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # group size
        [alias('Size')]
        [parameter(Mandatory, Position = 0)]
        [uint]$Count,

        # objects
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject

    )

    begin {
        $buffer = [list[object]]::new()
    }
    process {
        $buffer.Add($InputObject)
        if ($buffer.Count -ge $Count) {
            , @($buffer)
            $buffer.Clear()
            return
        }
    }
    end {
        'ended with?', $buffer.Count -join ' ' | Write-Debug
        , @( $buffer)
    }
}
if (! $experimentToExport) {
    h1 'module'
    # ...


    h1 'modulus determines breaks'
    0..99 | ForEach-Object { $i = 0 } {
        $i++
        $paint = '▆' * 3 -join ''
        if ($i % 10 -eq 0) {
            $paint += "`n"
        }
        $Paint | Join-String -sep '' | Write-Color -fg "gray${_}"

    } | str str ' '

    $items = 0..99 | ForEach-Object { $i = 0 } {
        $paint = '▆' * 3 -join ''
        $Paint | Join-String -sep '' | Write-Color -fg "gray${_}"

    }
    $Items
    $items.count
    Write-Warning 'todo: use explicitly set RGB values'

    hr
    h1 'Using Group-Object'
    0..10 | Group-ObjectCount -Count 3

    h1 'to->json'
    0..10 | Group-ObjectCount -Count 3 | ConvertTo-Json

    h1 'Join-String'
    0..10 | Group-ObjectCount -Count 5 | ForEach-Object {
        $_ | Join-String -sep ', ' -op 'Group: '
    }

    h1 'inner to->json'
    0..10 | Group-ObjectCount -Count 5 | ForEach-Object {
        $_ | ConvertTo-Json
    }
}

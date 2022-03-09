#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-RepeatScriptBlock_minimal'
    )
    $experimentToExport.alias += @(
        'RepeatIt_minimal'
    )
}

function Invoke-RepeatScriptBlock_minimal {
    <#
    .synopsis
        Repeat X times, sleep each ?
    .description
    example cases:
        <ScriptBlock> [NumTimes] [SleepBetween]
        <ScriptBlock> [untilTime] [SleepBetween]

       1] Repeat -Count 4 -Sleep 10ms

       2] Repeat -Until '2hours'
    .example
        PS> RepeatIt_minimal 5 { 0.. 5 } { "`n`n"  } | str csv -SingleQuote
    .link
        Dev.Nin\Invoke-RepeatScriptBlock
    .link
        Dev.Nin\Invoke-RepeatScriptBlock_minimal
    .outputs
          [string | None]

    #>
    [Alias(
        'RepeatIt_minimal'
    )]
    [CmdletBinding()]
    param(
        # count
        [Parameter(Mandatory, Position = 0)]
        [int]$Count,

        # function to eval
        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [ScriptBlock]$ScriptBlock,

        # Do you join on every inner or outer
        [switch]$JoinInner,


        # Regular JoinString -Sep parametter
        [Alias('SeparatorScriptBlock')]
        [Parameter(Position = 2)]
        [object]$SeparatorObject
    )

    begin {
    }
    process {
        if ($SeparatorObject -is 'scriptblock') {
            Write-Error 'ScriptBlockNYIJ'
        }

        if ($JoinInner) {
            $i..$Count | ForEach-Object {
                & $ScriptBlock | Join-String -sep $SeparatorObject
            }
            return
        }
        if (! $JoinInner) {
            $i..$Count | ForEach-Object {
                & $ScriptBlock
            } | Join-String -sep $SeparatorObject
            return
        }

        end {

        }
    }
}


if (! $experimentToExport) {
    # ...
}

#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-RepeatScriptBlock'
    )
    $experimentToExport.alias += @(
        'RepeatIt'
    )
}

function Invoke-RepeatScriptBlock {
    <#
    .synopsis
        Repeat X times, sleep each . todo: See Stronx
    .description
    stronx:
        maybe he has a relative time completer
        as an attributes

    example cases:
        <ScriptBlock> [NumTimes] [SleepBetween]
        <ScriptBlock> [untilTime] [SleepBetween]

       1] Repeat -Count 4 -Sleep 10ms

       2] Repeat -Until '2hours'
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias(
        'RepeatIt'
        # 'DoUntil', #
        # 'DoXTimes' #
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(

        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [ScriptBlock]$ScriptBlock
    )

    begin {

    }
    process {

        # first
        throw 'NYI'
    }
    end {

    }
}

if (! $experimentToExport) {
    # ...
}
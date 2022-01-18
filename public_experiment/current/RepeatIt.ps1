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
        PS> RepeatIt 5 { 0.. 5 } { "`n`n"  } | str csv -SingleQuote
    .outputs
          [string | None]

    #>
    [Alias(
        'RepeatIt'
        # 'DoUntil', #
        # 'DoXTimes' #
    )]
    [CmdletBinding()]
    param(
        # count
        [Parameter(Mandatory, Position = 0)]
        [int]$Count,

        # function to eval
        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [ScriptBlock]$ScriptBlock,


        # string or scriptblock to join
        [Parameter(Position = 2)]
        [object]$SeparatorObject,

        [switch]$PipeToScriptblock
    )

    begin {
        

    }
    process {
        if ($PipeToScriptblock -and $SeparatorObject -is 'scriptblock') { 
            write-debug 'Pipe output to next
            failed examples:
            RepeatIt 3 { 0..4 } { $args.GetType() } -PipeToScriptblock -Debug
        '
            write-debug 'not finished param, validate what a better way to pipe to a 2nd block is'
            write-warning 'need the equiv of a any args func'
            foreach ($i in 1..$count) {
                $result = & $ScriptBlock
                & $PipeToScriptblock                
                # & $ScriptBlock | & $PipeToScriptblock
            }
            return
        } else {
            foreach ($i in 1..$count) {
                & $ScriptBlock
                
                if ($SeparatorObject -is 'string') {
                    $SeparatorObject
                }
                elseif ($SeparatorObject -is 'scriptblock') {
                    & $ScriptBlock
                }    
            }
            return
        }
    }
    end {

    }
}

if (! $experimentToExport) {
    # ...
}
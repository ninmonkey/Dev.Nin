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
    todo:
        InputObject pipe or praram ?
        Pipe a scripblock or pipe a func to repeat

    example cases:
        <ScriptBlock> [NumTimes] [SleepBetween]
        <ScriptBlock> [untilTime] [SleepBetween]

       1] Repeat -Count 4 -Sleep 10ms

       2] Repeat -Until '2hours'
    .example
        PS> RepeatIt 5 { 0.. 5 } { "`n`n"  } | str csv -SingleQuote
    .link
        Dev.Nin\Invoke-RepeatScriptBlock
    .link
        Dev.Nin\Invoke-RepeatScriptBlock_minimal
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
        [Alias('SeparatorScriptBlock')]
        [Parameter(Position = 2)]
        [object]$SeparatorObject,

        <#
        #4 , #6 WIP : Add optional sleep on iterations
        # this would allow me to pipeline results, instead of evaluating everything, and then pipe
        this may be the place to use SteppablePipeline?
        Something like

            # if this could to pipe line
            & $ScriptBlock | & $PipeToScriptblock

            # instead of
            (& $ScriptBlock) | & $PipeToScriptBlock



        #>
        [switch]$PipeToScriptblock
    )

    begin {


    }
    process {

        $i..$Count | ForEach-Object {
            & $ScriptBlock

            return
            #     if ($false) {
            #         if ($PipeToScriptblock -and $SeparatorObject -is 'scriptblock') {
            #             Write-Debug 'Pipe output to next
            #     failed examples:
            #     RepeatIt 3 { 0..4 } { $args.GetType() } -PipeToScriptblock -Debug
            # '
            #             Write-Debug 'not finished param, validate what a better way to pipe to a 2nd block is'
            #             Write-Warning 'need the equiv of a any args func'
            #             foreach ($i in 1..$count) {
            #                 $result = & $ScriptBlock
            #                 & $PipeToScriptblock
            #                 # & $ScriptBlock | & $PipeToScriptblock
            #             }
            #         }
            #         return
            #     } else {
            #         if ($true -and 'new pipeline test mode') {
            #             $i..$Count | ForEach-Object {
            #                 $i = $_
            #                 if ($SeparatorObject -is 'ScriptBlock') {
            #                     & $ScriptBlock | & $PipeToScriptblock
            #                     # or
            #                 } else {
            #                     & $ScriptBlock | Join-String -sep $SeparatorObject

            #                 }
            #             }
            #             return
            #         } else {
            #             foreach ($i in 1..$count) {
            #                 & $ScriptBlock

            #                 if ($SeparatorObject -is 'string') {
            #                     $SeparatorObject
            #                 } elseif ($SeparatorObject -is 'scriptblock') {
            #                     & $ScriptBlock

            #                 }
            #             }
            #             return
            #         }
            #     }
        }
    }
    end {

    }
}

if (! $experimentToExport) {
    # ...
}

#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_MaxLimits' # ''
    )
    $experimentToExport.alias += @(
        # '_MaxLimits'
    )
}


'steppable pipeline ask sci. goal:1'

function _MaxLimits {
    [cmdletbinding()]
    param(
        <#
        what exactly is an iteration depends on the context/pipline its used by
        #>
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        [Alias('Iter')]
        [Parameter(Mandatory, Position = 0)]
        [int]$MaxIterations,


        [Alias('DeltaTime', 'RelativeTs')]
        [Parameter(Mandatory, Position = 1)]
        [object]$RelativeTimespan
    )
    begin {
        $startDt = [datetime]::Now
        $maxDt = $startDt + (RelativeTs $RelativeTimespan)
        $iterCount = 0
        $endingTriggerWas = $null
        $pipeIsDone = $false
    }
    process {
        $iterCount++
        $now = [datetime]::Now
        if ($pipeIsDone) {
            return
        }

        if ($now -gt $maxDt) {
            $endingTriggerWas = 'time'
            $pipeIsDone = $true

            return
        }
        if ($iterCount -gt $MaxIterations) {
            $endingTriggerWas = 'iters'
            $pipeIsDone = $true
            return
        }
        $InputObject
        $deltaDt = $now - $startDt
        @{
            Iter         = $MaxIterations
            DeltaElapsed = $deltaDt.TotalSeconds.ToString('n3')
        }
        | Format-Table -auto | Out-String | Write-Information


    }
    end {
        "trigger: $endingTriggerWas" | Write-Debug
    }
}

if (! $experimentToExport) {
    # ...
}

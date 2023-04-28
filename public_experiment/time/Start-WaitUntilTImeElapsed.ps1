#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # Start-WaitUntilTimeElapsed
        # '_waitUntil'
    )
    $experimentToExport.alias += @(
        # ''

    )
}



if (! $experimentToExport) {
    # ...
}


function _waitUntil {
    param(
        [Alias('waitForTs')]
        [Parameter(Mandatory, ParameterSetName = 'waitForTs')]
        [string]$WaitForRelativeTs,

        [Alias('waitUntilDt')]
        [Parameter(Mandatory, ParameterSetName = 'waitUntilDt')]
        [datetime]$WaitUntilDatetime,

        [hashtable]$Options
    )
    begin {
        $now = [datetime]::Now

        $later = RelativeTs $WaitForRelativeTs

        $startDt = [datetime]::Now
        $config = @{
            SleepSize = $DelayMs ?? 0.1
            Echo      = $true
        }

    }
    process {
        throw 'merged logic is totally wrong, split/rewrite'
        function _waitForTs {
            param( $startDt, $RelativeTimespan )

            while ($true) {
                $now = [datetime]::Now
                $testTimeElapsedSplat = @{
                    StartTime        = $startDt
                    RelativeTimespan = $RelativeTimespan
                }

                if (Test-TimeElapsed @testTimeElapsedSplat) {
                    break;
                }

            }
        }
        switch ($PSCmdlet.ParameterSetName) {
            'WaitForTs' {
                _waitForTs -startDt $startDt -RelativeTimespan $Rel
                break
            }
            # 'waitUntilDt' {

            # }
            default {
                throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }
    }
    end {
        $endDt = [DateTime]::Now
        $endDt - $startDt | ForEach-Object TotalMilliSeconds | label 'delta ms'
    }
}

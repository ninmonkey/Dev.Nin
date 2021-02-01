function Start-DevTimer {
    <#
    .SYNOPSIS
    Experimenting with a timer alarmm, optionally with BurntToast

    .DESCRIPTION

    .EXAMPLE
    see also: <https://ephos.github.io/posts/2018-8-20-Timers>

    .NOTES
    future:
        - [ ] named-timers
        - [ ] actual sleep timer with a delay
        - [ ] refactor difference between
            1] an alarm that alerts, or 2
            2] timer that counts up, a stop watch.

    #>
    param(
        # DurationMinutes
        [Parameter(Mandatory, Position = 0)]
        [Alias('Minutes')]
        [uint]$DurationMinutes
    )

    $_config = @{
        # SleepSecs = 6 * 60
        SleepSecs = 0.2
    }

    $watch = [System.Diagnostics.Stopwatch]::StartNew()
    Write-Warning 'wip, verify it writes to term correctly '

    try {
        while ($true) {
            $strMinutes = $watch.Elapsed.TotalMinutes.ToString('n')
            if ( $watch.Elapsed.TotalMinutes -gt $DurationMinutes) {
                Write-Warning $strMinutes
                Label -fg red 'Elapsed Minutes' $strMinutes

                $splat_Toast = @{
                    Text   = "Elapsed: $strMinutes minutes"
                    Silent = $true
                    # SuppressPopup = $True
                }

                New-BurntToastNotification @splat_Toast
            } else {
                Label -fg green 'Elapsed Minutes' $strMinutes

            }
            Start-Sleep $_config.SleepSecs

        }
    } catch {
        throw $_
    } finally {
        $watch.Stop()
        $watch = $null
    }
}

function Stop-DevTimer {
    # alarm, toast
    throw "future: When timers have names"
}
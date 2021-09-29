
$experimentToExport.function += @(
    'Invoke-ToastAlarm'
    'Invoke-ToastAnnoyAlarm'
)
$experimentToExport.alias += @(
    '_toastTimer'
    
    'Alarm'
    'Alarm-Toast🍞'

    'Annoy'
    'Annoy-Toast🍞'
)


function Invoke-ToastAnnoyAlarm {
    <#
    .synopsis
        run first time, like 20mins, then repeat on fast timer to annoy to force a quick response
    .notes
        future:
            -  [ ] validate $EndTime parameter **before** running either
    .link
        Alarm    

    #>
    [Alias('Annoy', 'Annoy-Toast🍞')]
    param (      
        [Alias('Start')]
        [Parameter(Mandatory)]
        [string]$FirstTime,

        [Parameter(Mandatory)]
        [string]$EndTime
    )

    end {
        @(
            "first timer: '$FirstTime'"
            "RepeatTimer: '$EndTime'"
        )
        | Join-String -sep ', ' | write-textcolor 'hotpink2'
        # | Write-Information  # for now, write to be consistant with alarm
        # $FirstTime = '20m', $EndTime = '2m' )
        Invoke-ToastAlarm -RelativeTimeString $FirstTime -Message "FirstAlarm: '$FirstTime'" -Repeat:$false                
        Invoke-ToastAlarm -RelativeTimeString $EndTime -Message "Annoying: per '$EndTime'" -Repeat:$true
    }
}
function Invoke-ToastAlarm {
    <#
  .synopsis
   super easy to invoke timer
   .link
    Annoy
  .example
       _toastTimer 30m
  #>

    [alias('Alarm', 'Alarm-Toast🍞')]
    [cmdletbinding()]
    param(
        # Relative Time string, like '30m'
        # todo: future:
        [Parameter(Mandatory, Position = 0)]
        [string]$RelativeTimeString = '30m',

        # Message
        [Parameter(Position = 1)][String]$Message,

        # Silent?
        [Parameter()][switch]$Silent,

        # Repeat automatically? (currently until kill)
        [Parameter()][switch]$Repeat
    )
    process {
        $delta = RelativeTs $RelativeTimeString
        do {
            $when = (Get-Date) + $delta
            'Alarm set for: {0}' -f ( $when.ToShortTimeString() ) 
            #| write-information
            while ( (Get-Date) -lt $when ) {
                Start-Sleep -Seconds 1
            }

            $splat_Toast = @{
                Text  = "$Message`n🐒"
                Sound = 'Alarm3'
            }
            if ($Silent) {
                $splat_Toast.Remove('Sound')
                $splat_Toast.Add('Silent', $true)
            }


            New-BurntToastNotification @splat_Toast
        } while ($Repeat)
    }
}


$experimentToExport.function += @(
    '_toastTimer'
)
$experimentToExport.alias += @(
    'Alarm'
)


function _toastTimer {
    <#
  .synopsis
   super easy to invoke timer
  .example
       _toastTimer 30m
  #>

    [alias('Alarm')]
    [cmdletbinding()]
    param(
        # Relative Time string, like '30m'
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

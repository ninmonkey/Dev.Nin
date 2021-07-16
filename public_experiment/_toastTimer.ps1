
$experimentToExport.function += '_toastTimer'
$experimentToExport.alias += 'Alarm'


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
        [string]$RelativeTimeString = '30m'
    )
    $delta = RelativeTs $RelativeTimeString
    $when = (Get-Date) + $delta
    'Alarm set for: {0}' -f ( $when.ToShortTimeString() )
    while ( (Get-Date) -lt $when ) {
        Start-Sleep -Seconds 1
    }
    New-BurntToastNotification -Text 'Time up 🐒' -Sound 'Alarm3'
}

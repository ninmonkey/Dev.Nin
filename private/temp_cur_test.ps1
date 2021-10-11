# Import-Module dev.nin, ninmonkey.console -Force 3>$NULL
# Import-Module dev.nin -Force 3>$NULL
Import-Module dev.nin -Force
'hi world'
# 'rgbcolor' | New-TypeInfo
# hest explicit
($PSVersionTable -as 'hashtable' ).GetEnumerator() | ForEach-Object {
    #$_.key, $_.Value
    $_.Value | write-color 'pink'
    hr
    $_.key | write-color 'seagreen2'
    hr
}
hr

Dev.New-Sketch PowerShell Style🎨, Cli_Interactive🖐 fast_trace_route -WhatIf


return
# $samples3 | _formatErrorSummary | Select-Object -First 3
$samples3 ??= $error
$samples3 | _formatErrorSummary | Select-Object -First 3

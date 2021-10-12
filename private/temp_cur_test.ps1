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
hr
'last' | write-color (find-color green | Get-Random -Count 1 )
$NinProfile_Dotfiles | Format-Dict
hr
Format-Dict -InputObject $NinProfile_Dotfiles
hr
'options' | write-color orange

$Options = @{
    Config = @{
        AlignKeyValuePairs   = $false
        FormatControlChar    = $true
        TruncateLongChildren = $True
    }
}
Format-DIct $Options.Config

Format-Dict -InputObject $NinProfile_Dotfiles -Options $Options

hr
write-color yellow -t 'Show nested details?'
write-color orange -t '1) $Options'
Format-Dict $Options

write-color orange -t '2) $Options.Config'
Format-Dict $Options.Config
hr


return
# $samples3 | _formatErrorSummary | Select-Object -First 3
$samples3 ??= $error
$samples3 | _formatErrorSummary | Select-Object -First 3

# Import-Module dev.nin, ninmonkey.console -Force 3>$NULL
# Import-Module dev.nin -Force 3>$NULL
# 'rgbcolor' | New-TypeInfo
# hest explicit
& {
    Import-Module dev.nin -Force
    hr

    $RunTest = @{
        'New-Sketch'               = $true
        'Format-Dict'              = $true
        'Format-Dict.Verbose'      = $true
        'Format-Dict.CustomConfig' = $true # 📌 best
    }


    if ($RunTest.'Format-Dict.Verbose') {

        ($PSVersionTable -as 'hashtable' ).GetEnumerator() | ForEach-Object {
            #$_.key, $_.Value
            $_.Value | write-color 'pink'
            hr
            $_.key | write-color 'seagreen2'
            hr
        }
        hr

    }
    if ($RunTest.'New-Test') {
        Dev.New-Sketch PowerShell Style🎨, Cli_Interactive🖐 fast_trace_route -WhatIf
        hr
        'last' | write-color (find-color green | Get-Random -Count 1 )
    }

    if ($RunTest.'Format-Dict.CustomConfig') {

        $NinProfile_Dotfiles | Format-Dict
        hr
        Format-Dict -InputObject $NinProfile_Dotfiles
        hr
        "it 'default alignment'" | write-color orange
        hr

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
        "it 'alignment'" | write-color orange
        hr
        $Options = @{
            Config = @{
                AlignKeyValuePairs   = $true
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
    }

    if ($RunTest.'_formatErrorSummary') {
        # $samples3 | _formatErrorSummary | Select-Object -First 3
        $samples3 ??= $error
        $samples3 | _formatErrorSummary | Select-Object -First 3
    }
}
# Import-Module dev.nin, ninmonkey.console -Force 3>$NULL
# Import-Module dev.nin -Force 3>$NULL
# 'rgbcolor' | New-TypeInfo
# hest explicit

Import-Module 'dev.nin' -Force


    hr

    $RunTest = @{
        'Code-Insider' = $true
        'GotoError'                = $false
        'New-Sketch'               = $false
        'Format-Dict'              = $false
        'Format-Dict.Verbose'      = $false
        'Format-Dict.CustomConfig' = $false # 📌 best
        'RegexTestFilepath'        = $false
    }



    if($RunTest.'Code-Insider') {
        # & {

    $codeIvEnvSplat = @{
        WhatIf = $true
        TargetPath = ls . -file | select -first 1 #'.\test.log'
    }

    CodeI-vEnv @codeIvEnvSplat #-ea break

    $codeIvEnvSplat = @{
        WhatIf = $true
        TargetPath = '.'
    }

    CodeI-vEnv @codeIvEnvSplat  #-ea break
    # CodeI-vEnv -WhatIf .\test.log -LineNumber 20 -ea break
    # CodeI-vEnv -WhatIf .\test.log -LineNumber 20 -ea inquire
    }

    # }

    if ($RunTest.'GotoError') {
        if ($savedErr) {
            $savedErr[0] | _processErrorRecord_AsLocation
            hr

            $savedErr[0] | gotoError -PassThru
        } else {
            Write-Error 'No Saved Errors'
        }
    }
    if ($RunTest.'Format-Dict.Verbose') {

        ($PSVersionTable -as 'hashtable' ).GetEnumerator() | ForEach-Object {
            #$_.key, $_.Value
            $_.Value | Write-Color 'pink'
            hr
            $_.key | Write-Color 'seagreen2'
            hr
        }
        hr

    }
    if ($RunTest.'New-Test') {
        Dev.New-Sketch PowerShell Style🎨, Cli_Interactive🖐 fast_trace_route -WhatIf
        hr
        'last' | Write-Color (find-color green | Get-Random -Count 1 )
    }

    if ($RunTest.'Format-Dict.CustomConfig') {

        $NinProfile_Dotfiles | Format-Dict
        hr
        Format-Dict -InputObject $NinProfile_Dotfiles
        hr
        "it 'default alignment'" | Write-Color orange
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
        "it 'alignment'" | Write-Color orange
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
        Write-Color yellow -t 'Show nested details?'
        Write-Color orange -t '1) $Options'
        Format-Dict $Options

        Write-Color orange -t '2) $Options.Config'
        Format-Dict $Options.Config
        hr
    }

    if ($RunTest.'_formatErrorSummary') {
        # $samples3 | _formatErrorSummary | Select-Object -First 3
        $samples3 ??= $error
        $samples3 | _formatErrorSummary | Select-Object -First 3
    }

    if ($RunTest.RegexTestFilepath) {


        $Samples = @{}
        $Samples.Valid = @(
            'ormat_color.ps1:3:1',
            'ormat_color.ps1:33245:133',
            'foobar.ps1:3:5',
            'c:\foo  a\foobar.ps1:3',
            'c:\foo  a\foobar.ps1',
            'bar.t',
            'foo:3',
            '3:fo.ps:3:1'
        ) | Sort-Object -Unique | ForEach-Object {
            @{ SamplePath = $_ ; Expected = $True }
        }
        $Samples.Invalid = @(
            'c:\foo  \foobar.ps1:a:3:',
            'c:\foo  \foobar.ps1:3:',
            'c:\foo  \foobar.ps1:',
            'bar:4:6:',
            'bar:4: 6',
            'bar:4:6:',
            ':2:3:'
        ) | Sort-Object -Unique | ForEach-Object {
            @{ SamplePath = $_ ; Expected = $False }
        }

        $re = @'
(?x)
^
(?<FullName>
  .+
)
# --goto <file:line[:character]> Open a file
(?<Suffix>
  \:
  (?:
    \:
    (?<Line>\d+)
  )?
  (?:
    \:
    (?<Column>\d+)
  )?
)?
$
'@

        $Samples.valid.'SamplePath' | ForEach-Object {
            $_ | Write-Color pink
            $_ -match $re | Should -Be $True

        }
    }
}

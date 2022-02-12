# Import-Module dev.nin, ninmonkey.console -Force 3>$NULL
# Import-Module dev.nin -Force 3>$NULL
# 'rgbcolor' | New-TypeInfo
# hest explicit

# $ErrorActionPreference = 'stop'
$importModuleSplat = @{
    Force   = $true
    Verbose = $true
    # Debug = $true
    Name    = 'dev.nin'
}

# Import-Module @importModuleSplat #-ea break

$origPrompt = Get-Item function:prompt
function prompt {
    "$($global:error.count)`n($pwd)`ndev.nin> "
}

'tests?'
hr
$RunTest = @{
    'SkipEverything'           = $true
    'EarlyQuit'                = $true #  like SkipEverything but more
    'GhRepoList'               = $true
    'Resolve-TypeName'         = $true
    'Resolve-TypeNamePester'   = $false
    'Code-Insider'             = $false
    'GotoError'                = $false
    'New-Sketch'               = $false
    'Format-Dict'              = $false
    'Format-Dict.Verbose'      = $false
    'Format-Dict.CustomConfig' = $false # 📌 best
    'RegexTestFilepath'        = $false
}
$runTest | Format-Table

if ($RunTest.'SkipEverything') {
    'SkipEverything: Early Quit'
    return
}

& {
    if ($RunTest.GhRepoList) {
        # Invoke-GHConeRepo -
    }

    if ($RunTest.EarlyQuit) {
        $RunTest | Format-Table  #format-dict
        return
    }

    if ($RunTest.'Resolve-TypeName') {
        'hashtable' | Resolve-TypeName
    (Get-Item . ) | Resolve-TypeName

        [Text.ASCIIEncoding] | Resolve-TypeName

        # this one errors because it's not string
        # [ASCIIEncoding] | resolve-typename
        'ASCIIEncoding' | resolve-typename
    }
    if ($RunTest.'Resolve-TypeNamePester') {
        $invokePesterSplat = @{
            Path   = 'C:/Users/cppmo_000/SkyDrive/Documents/2021/powershell/My_Github/dev.nin/public_autoloader/current/Resolve-TypeName.tests.ps1'
            Output = 'detailed'
        }

        '...' | label 'before'
        Invoke-Pester @invokePesterSplat
        '...' | label 'after'
    }

    if ($RunTest.'Rune-Detail') {
        $grapheme = '👩🏼‍🦳'
        $grapheme.EnumerateRunes() | Format-Table
        hr
        $grapheme | Get-RuneDetail
    }


    if ($RunTest.'Code-Insider') {
        # & {

        $codeIvEnvSplat = @{
            WhatIf     = $true
            TargetPath = Get-ChildItem . -File | Select-Object -First 1 #'.\test.log'
        }

        CodeI-vEnv @codeIvEnvSplat #-ea break

        $codeIvEnvSplat = @{
            WhatIf     = $true
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

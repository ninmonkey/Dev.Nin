if ($False) {
    $Targets = @(
        @{ Name = 'ISP Dns1' ; Target = '205.171.2.25' }
        @{ Name = 'ISP Dns2' ; Target = '205.171.3.25' }
        @{ Name = 'Google Dns' ; Target = '8.8.8.8' }
        @{ Name = 'CloudFlare Dns' ; Target = '1.1.1.1' }

    ) | ForEach-Object {
        $_['Color'] = Get-ChildItem fg: | Get-Random -Count 1
        [pscustomobject]$_
    }

    $Targets | Format-Table
    $FakeSleepSecs = 0.5

    # test-conn
    [object[]]$ManualColorMap = @(
        [rgbcolor]'DeepPink4' # evals as mode: X11
        # [rgbcolor]'#FFEC8B'   # evals as mode: Rgb24Bit
        [rgbcolor]'LightGoldenrod1'
        [rgbcolor]'DarkSeaGreen4'
        [rgbcolor]'SeaGreen1'
        [rgbcolor]'Seashell2'
        [rgbcolor]'LightSlateGray'
        [rgbcolor]'Honeydew2'
        [rgbcolor]'Turquoise1'
        [rgbcolor]'#FFA500'
        [rgbcolor]'Bisque2'
        [rgbcolor]'Gray55'
        [rgbcolor]'MediumSpringGreen'
        [rgbcolor]'Firebrick'
        [rgbcolor]'#ADFF2F'
        [rgbcolor]'#CDCD00'

        # [rgbcolor]'#8B0A50'
    )

    [object[]]$ColorMap = @(
        $ManualColorMap | Get-Random -Count ($Targets.Count)
    )

    $ManualColorMap

    function _testSequential {

        '-> sequential'
        | Join-String -op 'Depth'
        $Targets | ForEach-Object {
            $cur = $_
            # Test-Connection -TimeoutSeconds 1 -TargetName $_.Target -Count 2
            $count = 3
            1..$count | ForEach-Object {
                $NameStr = @(
                    Write-Text $cur.Name -fg $cur.Color
                ) -join ''
                "ping: $NameStr $($cur.Target)"
                Start-Sleep $fakeSleepSecs
            }
        }
    }

    function _testParallel {

        '-> sequential'
        $Targets | ForEach-Object {
            $cur = $_
            # Test-Connection -TimeoutSeconds 1 -TargetName $_.Target -Count 2
            $count = 3
            1..$count | ForEach-Object {
                $NameStr = @(
                    Write-Text $cur.Name -fg $cur.Color
                ) -join ''
                "ping: $NameStr $($cur.Target)"
                Start-Sleep $fakeSleepSecs
            }
        }
    }


    $TestConfig = @{
        Sequential = $false
        Parallel   = $true
    }
    $FakeSleepSecs = 0.01
    # $FakeSleepSecs = 0.0001

    $TestConfig | Format-Table

    if ($TestConfig.Sequential) {
        _testSequential
    }
    if ($TestConfig.Parallel) {
        _testParallel
    }
}

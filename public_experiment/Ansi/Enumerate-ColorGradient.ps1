#Requires -Version 7
#Requires -Module pansies

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_enumerateColorGradient'
    )
    $experimentToExport.alias += @(
        '_enumerateNextColorGradient'
    )
}


# this is the actual function/module state that would be private
$__localMeta = @{
    lastIndex = 0
}
$gradients = @{
    'PulseRedGreen' = Get-Gradient -StartColor '#FE1C14' -EndColor '#66CDAA'
    'SoftRedSmooth' = Get-Gradient -StartColor '#FF1C14' -EndColor '#BC8F8F'
    'Greenish'      = Get-Gradient -StartColor '#008C2E' -EndColor '#CA96FF' -Width 10
}
function _enumerateColorGradient {
    <#
    .synopsis
        Cycles through a color gradient
    .example
        0..100 | %{
            $c = _enumerateColorGradient
            (get-date).ToLongTimeString() | Write-color $c
            sleep 0.3
        }
    .outputs
        [rgbcolor]
    #>
    [ALias(
        '_nextColor',
        '_enumerateNextColorGradient'
    )]
    [cmdletbinding(DefaultParameterSetName = 'EnumerateColor')]
    param(
        # intialize color
        [Alias('Set')]
        [Parameter(ParameterSetName = 'InitColor')][switch]$Init,

        # Color value
        [Parameter(ParameterSetName = 'InitColor', Mandatory)]
        [object[]]$Gradient
    )
    process {
        $state = $script:__localMeta
        switch ($PSCmdlet.ParameterSetName) {
            'InitColor' {
                $state.gradient = $Gradient
                $state.lastIndex = 0
                return
            }

            default {
                $state.lastIndex ??= 0
                $state.gradient ??= Get-Gradient -StartColor '#008C2E' -EndColor '#CA96FF' -Width 10

                $state.gradient[$state.lastIndex] # the only emit

                $state.lastIndex++
                if ($state.lastIndex -ge $state.gradient.psbase.count) {
                    $state.lastIndex = 0
                }

            }
        }
    }
}

if (! $false) {
    # ...

    # $state | format-dict -Options @{'PrefixLabel' = 'state' } | Write-Color 'magenta'
    # | Write-Debug
    # $state.lastIndex++
    # $state | Format-ControlChar | write-color 'value'

    # if ($__lastIndex.lastIndex -ge $colors.Length) {
    #     $script:__localMeta.lastIndex = 0
    # }
    # $colors[$script:__localMeta.lastIndex]
    # $script:__localMeta.lastIndex++
    # Write-Debug $script:__localMeta.lastIndex
    function _testIt {

        $files = Get-ChildItem ~ | Select-Object -First 30

        $files | ForEach-Object {
            $cur = $_
            Write-Color -t $cur.Name (_enumerateColorGradient)
        } | str Csv
    }

    h1 'none'
    _testIt

    h1 'clist'
    $clist = 'pink', 'red', 'breen', 'blue' | convert 'rgbcolor'
    _enumerateColorGradient -Set -Gradient ($clist)
    _testIt

    h1 'softredsmooth'
    _enumerateColorGradient -Set -Gradient ($gradients.SoftRedSmooth)
    _testIt

    h1 'green'
    _enumerateColorGradient -Set -Gradient ($gradients.Greenish)
    _testIt

    return
    $files ??= Get-ChildItem ~ -Depth 3
    $files | Get-Random -Count 20 | ForEach-Object {
        $cur = $_

        $c = _enumerateColorGradient
        @(
            $c | Write-AnsiBlock -NoName
            $cur.Name
        ) | str csv $cur
    }
    hr 2

    return
    0..6 | ForEach-Object {
        "x: $_ "
        $c = _enumerateColorGradient -Debug
        if ($null -eq $c) {
            throw 'should not be null'
        }
        'x is color'
        | Write-Color -fg $c
    }
    $clist = 'pink', 'red', 'breen', 'blue' | convert 'rgbcolor'
    _enumerateColorGradient -Set -Gradient ($clist)


    Write-Color -t 'hi world' -fg (_enumerateColorGradient) -infa Continue -Debug -Verbose
    hr
    return
    Get-ChildItem . -File -d 3 | ForEach-Object {
        $cur = $_
        $Cur.name
        #   | str Prefix 'sdfd'
        | Write-Color 'green'

        'test'
        | Write-Color 'red'
        # | Write-Color (_nextColor -ea stop) -t $_
    }
    | Select-Object -First 20
    | str csv
}

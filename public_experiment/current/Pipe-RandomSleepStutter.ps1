#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Pipe-RandomSleepStutter'
    )
    $experimentToExport.alias += @(
        'Rand->Stutter'
    )
}

function Pipe-RandomSleepStutter {
    <#
        .synopsis
            .
            synopsis suger to get a sleep delay, and somewhat random
        .notes
            - [ ] add smoothing to random values
        .example
            PS>
        #>
    # [outputtype( [string[]] )]
    [Alias('Rand->Stutter')]
    [cmdletbinding(DefaultParameterSetName = 'AsValues')]
    param(
        # docs
        # [Alias('y')]

        # seconds
        [parameter(ParameterSetName = 'AsValues', Position = 0)]$MinValue,
        # seconds
        [parameter(ParameterSetName = 'AsValues', Position = 1)]$MaxValue,

        # quick preset
        [parameter(Mandatory, ParameterSetName = 'preset', position = 0)]
        [validateSet('0.1s', '1s', '5s')]
        [string]$Preset,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        [hashtable]$ColorType = Join-Hashtable ($ColorType ?? @{}) ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            AlignKeyValuePairs = $true
            Title              = 'Default'
            DisplayTypeName    = $true
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
        switch ($Preset) {
            '0.1s' {
                $Config.MinValue = 0.01
                $Config.MaxValue = 0.1
            }
            '1s' {
                $Config.MinValue = 0.5
                $Config.MaxValue = 1.5
            }
            '5s' {
                $Config.MinValue = 4
                $Config.MaxValue = 5
            }
            '10s' {
                $Config.MinValue = 7
                $Config.MaxValue = 15
            }
            default {
                $Config.MinValue = 0.1
                $Config.MaxValue = 3
            }
        }
    }
    process {
        $randSleep = Get-Random -Minimum $Config.MinValue -Maximum $MaxValue -Count 1
        Start-Sleep $randSleep
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
}

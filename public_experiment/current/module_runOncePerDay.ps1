#Requires -Version 7

if ( $experimentToExport ) {
    return
    $experimentToExport.function += @(
        # 'Invoke-RunOncePerDay'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}
[list[object]]$___throttleInvoke ??= [list[object]]::new()

class ThrottledTask {
    [string]$Name
    [string]$Description
    [ScriptBlock]$ScriptBlock
    [timespan]$MinimumThrottleTime
    [IO.FileInfo]$Source #null is valid. [string]::empty is not

    ThrottledTask($Name, $Description, $RelativeTimeSpan, $ScriptBlock) {
        $this.Name = $Name
        $this.Description = $Description
        $this.ScriptBlock = $ScriptBlock
        $convertToTimespanSplat = @{
            RelativeText = $RelativeTimeSpan
            ZeroIsValid  = $true
        }

        $this.MinimumThrottleTime = Ninmonkey.Console\ConvertTo-Timespan @convertToTimespanSplat
        $this.Source = if ([string]::IsNullOrWhiteSpace($PSCommandPath)) {
            $null
        } else {
            Get-Item $PSCommandPath
        }
    }
    [string]ToString() {
        return '{0}: {1}' -f @($this.Name, $this.Description)
    }
}

function Invoke-RunOncePerDay {
    <#
    .synopsis
        .async BG tasks or at least ran *after* profile, for 1per/unit/ autorunners in profile
    .description
        .async BG tasks or at least ran *after* profile, for 1per/unit/ autorunners in profile
    .notes
        .
    .example
        PS> Invoke-RunOncePerDay -WhatIf
    #>
    # [outputtype( [string[]] )]
    # [Alias('x')]
    [cmdletbinding(SupportsShouldProcess)]
    param(
        # docs
        # [Alias('y')]
        [parameter(Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            AlignKeyValuePairs = $true
            Title              = 'Default'
            DisplayTypeName    = $true
        }
        [list[object]]$TaskList = [list[object]]::new()
        $TaskList.Add(
            [pscustomobject]@{
                Label           = 'foo'
                TaskScriptBlock = {
                    'Doing: "Foo" stuff'
                }
            }
        )

        $Config = Join-Hashtable $Config ($Options ?? @{})
        $PSBoundParameters | Format-dict #-title 'PSBoundParameters'
    }
    process {
        if ($WhatIfPreference) {
            '-WhatIf'
        } else {
            'live'
        }
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
    Invoke-RunOncePerDay -whatif
    [ThrottledTask]::new('a', 'b', { 'no-op' })
}

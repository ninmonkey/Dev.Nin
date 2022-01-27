#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-RunOncePerDay'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

class ThrottledTaskInfo {
    <#
    .synopsis
        Describes a throttled task
    .notes
        future propertiesd

            [bool]Enabled
            [datetime]LastRuntime
    #>
    # misc name
    [string]$Name

    # misc description
    [string]$Description

    # Actual task code
    [ScriptBlock]$ScriptBlock

    # required throttle time since last run
    [timespan]$MinimumThrottleTime

    # filepath to task instance
    [IO.FileInfo]$Source #null is valid. [string]::empty is not

    ThrottledTaskInfo($Name, $Description, $RelativeTimeSpan, $ScriptBlock) {
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
        return "{0}: {1}`n{2}`n{3}" -f @(
            $this.Name
            $this.MinimumThrottleTime
            $this.Description
            $this.Source
        )
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

        # [Alias('y')]
        [parameter(ParameterSetName = 'OnlyListAll')]
        [switch]$ListAll,



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
        Write-Warning 'left off here'
        Write-Warning 'static rack manager? <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-7.1#example-using-static-attributes-and-methods>'
        switch ($PSCmdlet.ParameterSetName) {
            'OnlyListAll' {
                'listing  .... wip ... '
                $AppSourcePath = Get-Item -ea stop Join-Path $PSScriptRoot 'throttledTasks'

                Get-ChildItem $AppSourcePath *.ps1
                | Where-Object Name -NotMatch '\.tests.ps1$'

                hr
                'Registered...'
                $script:___throttleTaskList | Format-Table -auto

                break
            }

            default {

                # throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }
        throw 'NYI'
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
    Write-Warning "how do I add type to user session?`n => '$PSCommandPath'"
    [list[ThrottledTaskInfo]]$script:___throttleTaskList = [list[ThrottledTaskInfo]]::new()
    # ...
    Invoke-RunOncePerDay -whatif
    [ThrottledTaskInfo]::new('a', 'b', { 'no-op' })
}

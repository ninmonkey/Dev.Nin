function Restart-LGHubDriver {
    <#
    .synopsis
    fixes running LGHub when it's stuck

    .example
        Restart-LGHubDriver -ListOnly
        Restart-LGHubDriver -StopOnly

        Restart-LGHubDriver -Debug -WhatIf
    #>
    # [CmdletBinding(SupportsShouldProcess)]
    param(
        # don't actualy kill processes
        [Parameter()]
        [switch]$WhatIf,

        # show list, do not start
        [Parameter()]
        [switch]$ListOnly,

        # StopProcesses, do not start any
        [Parameter()]
        [switch]$StopOnly,

        # skip questions
        [Parameter()]
        [switch]$Confirm
    )

    $TargetProcessNames = 'lghub*', 'lghub_agent', 'lghub_updater'
    $Paths = @{
        AppPath = Get-Item "$env:ProgramFiles\LGHUB"
    }
    $splatJoinString_ArrayList = @{
        Separator    = ', '
        Property     = 'Name'
        OutputPrefix = '{'
        OutputSuffix = '}'
    }
    $joinStringSplat_MultiLineList = @{
        Separator    = "`n  "
        OutputPrefix = "`n  "
    }

    Label 'Path' $Paths.AppPath

    Get-ChildItem $Paths.AppPath *.exe
    | Join-String @joinStringSplat_MultiLineList -Prop 'Name'
    | Label 'AppExe' -bef 1  | Write-Debug



    Get-ChildItem $Paths.AppPath *.exe -Name | Sort-Object
    | Join-String @joinStringSplat_MultiLineList
    | Label 'exe names: ' -bef 1


    function _get-LGHubProcess {


        Get-Process -ea  SilentlyContinue -Name $TargetProcessNames
        | Sort-Object Name
        | Join-String @splatJoinString_ArrayList
        | Label 'Running' -bef 1
    }


    # list, shutdown, list, start, list
    _get-LGHubProcess
    if ($ListOnly) {
        return
    }

    $ScriptBlock = {
        $TargetProcessNames = 'lghub*', 'lghub_agent', 'lghub_updater'
        Get-Process -Name $TargetProcessNames -ea SilentlyContinue
        | Stop-Process -Confirm
        'Done'
    }

    _get-LGHubProcess | Write-Debug

    if (! $WhatIf ) {
        Start-Process 'pwsh' -Verb 'RunAs' -Wait -Args @(
            '-C'
            $ScriptBlock
        )
    }


    $startProcessSplat = @{
        FilePath = Join-Path $Paths.AppPath -ChildPath 'lghub_updater.exe'
        Verb     = 'RunAs'
        # ArgumentList
        WhatIf   = $WhatIf
        Confirm  = $Confirm
        Wait     = $false
    }

    _get-LGHubProcess | Write-Debug
    H1 'launching again'

    if (! $StopOnly ) {
        Start-Process @startProcessSplat
    }
    _get-LGHubProcess | Write-Debug

    $startProcessSplat.FilePath = Join-Path $Paths.AppPath -ChildPath 'lghub.exe'
    if (! $StopOnly ) {
        Start-Process @startProcessSplat
    }
    _get-LGHubProcess | Write-Debug

    $startProcessSplat.FilePath = Join-Path $Paths.AppPath -ChildPath 'lghub_agent.exe'
    $startProcessSplat.Remove('Verb')

    if (! $StopOnly ) {
        Start-Process @startProcessSplat
    }
    _get-LGHubProcess | Write-Debug

    H1 'final check'
    _get-LGHubProcess | Write-Debug
}

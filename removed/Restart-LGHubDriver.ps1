function Restart-LGHubDriver {
    <#
    .synopsis
    fixes running LGHub when it's stuck

    .example
        PS> # Normal kill, and restart

    .example
        PS> # only List processes, do not start or stop
        Restart-LGHubDriver -ListOnly
    .example
        PS> # Stop processes, but do not start them again
        Restart-LGHubDriver -StopOnly
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # don't actualy kill processes
        # [Parameter()]
        # [switch]$WhatIfX,

        # show list, do not start
        [Parameter()]
        [switch]$ListOnly,

        # StopProcesses, do not start any
        [Parameter()]
        [switch]$StopOnly

        # # skip prompt?
        # [Parameter()]
        # [switch]$ConfirmX
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

    H1 'Info'
    Label 'AppPath' $Paths.AppPath

    Get-ChildItem $Paths.AppPath *.exe
    | Join-String @joinStringSplat_MultiLineList -Prop 'Name'
    | Label 'AppExe' -bef 1  | Write-Debug



    Label 'Binaries in' $Paths.AppPath
    Get-ChildItem $Paths.AppPath *.exe -Name | Sort-Object
    | Join-String @joinStringSplat_MultiLineList



    function _getLGHubProcess {
        # format a single name result
        $psList = Get-Process -ea  SilentlyContinue -Name $TargetProcessNames
        $psList | Sort-Object Name
        | Join-String @splatJoinString_ArrayList
        | Label "Running $($psList.Count)" -bef 1 -LinesAfter 1
    }

    Write-Warning '-List, and -StopOnly work pretty good, code to actually launch it is not as stable'
    H1 'Start'
    # list, shutdown, list, start, list
    _getLGHubProcess
    if ($ListOnly) {
        return
    }

    $ScriptBlock = {
        $TargetProcessNames = 'lghub*', 'lghub_agent', 'lghub_updater'
        $items = Get-Process -Name $TargetProcessNames -ea SilentlyContinue
        # $items | ForEach-Object | Stop-Process -Confirm:$Confirm

        $items | ForEach-Object {
            $_ | Stop-Process -Confirm:$Confirm
            # if ($PSCmdlet.ShouldProcess($_, "Stop-Process")) {
            # }
        }
        Label 'Done' -sep ''
        Start-Sleep 2
    }

    _getLGHubProcess | Write-Debug
    H1 'Start pwsh $ScriptBlock'
    # if (! $WhatIf ) {
    # -Confirm:$Confirm -WhatIf:$WhatIf
    Start-Process 'pwsh' -Verb 'RunAs' -Wait -Args @(
        '-C'
        $ScriptBlock
    )
    # }

    $startProcessSplat = @{
        # ArgumentList
        Confirm     = $true
        FilePath    = Join-Path $Paths.AppPath -ChildPath 'lghub_updater.exe'
        Verb        = 'RunAs'
        Wait        = $false
        WhatIf      = $false #$WhatIf
        WindowStyle = 'Hidden'
    }

    H1 'After Process-Stop, befopre Launching'
    _getLGHubProcess

    if (! $StopOnly ) {
        Start-Process @startProcessSplat
        _getLGHubProcess | Join-String -sep ', ' | Label 'A] Running' | Write-Debug
    }

    $startProcessSplat.FilePath = Join-Path $Paths.AppPath -ChildPath 'lghub.exe'
    if (! $StopOnly ) {
        Start-Process @startProcessSplat
        _getLGHubProcess | Join-String -sep ', ' | Label 'B] Running' | Write-Debug
    }
    # _getLGHubProcess | Write-Debug | write-Debug

    $startProcessSplat.FilePath = Join-Path $Paths.AppPath -ChildPath 'lghub_agent.exe'
    $startProcessSplat.Remove('Verb')

    _getLGHubProcess | Join-String -sep ', ' |  Label 'C] Running' | Write-Debug

    if (! $StopOnly ) {
        Start-Process @startProcessSplat
        _getLGHubProcess | Join-String -sep ', ' | Label 'D] Running' | Write-Debug
    }
    _getLGHubProcess | Write-Debug

    H1 'After Launching'
    _getLGHubProcess
    Label 'E] Running'
}

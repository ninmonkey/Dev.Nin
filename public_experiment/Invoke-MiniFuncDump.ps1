$experimentToExport.function += @(
    'Invoke-MiniFuncDump'
)
$experimentToExport.alias += @(
    'InvokeFuncDump'
)

try {
    $script:__miniFuncDump ??= @{}
    $state = $script:__miniFuncDump ?? @{}

    $state.HistoryFastPrint = {
        Get-History | Join-String -sep "`n`n$(hr)" -Property CommandLine
    }
    $state.ListMyCommands = {
        '*filter->*', '*from->*', '*to->*' | ForEach-Object {
            Get-Command -m (_enumerateMyModule) $_
            hr
        }
    }
    $state.Alarm_asBase64 = {
        # [1] save: [2021-12-03] -> invoke alarm subprocess
        # todo: save to: console command palette command
        $commandStr = @'
Alarm -RelativeTimeString 3s -Message 'Started Alarm: 20ms /Repeat'
Dev.Nin\Alarm -RelativeTimeString 20m -Message 'bump' -Repeat
$When = (Get-Date).ToString('u')
"Fired log: $When" | Write-Debug
'@
        $commandStr | bat -l ps1
        $byteStr = [System.Text.Encoding]::Unicode.GetBytes($commandStr)
        $encodedCommand = [Convert]::ToBase64String($byteStr)
        $encodedCommand | Endcap🎨 Bold
        Start-Process 'pwsh' -ArgumentList @(
            '-encodedcommand', $encodedCommand
        ) -WindowStyle Hidden
    }
    $state.Alarm_asBackground_iter0 = {
        "'$PSCommandPath': Alarm_asBackground: Starts repeating timer, at 15m"
        $finalCmd = 'alarm -relativeTimeString {0} -message ''{1}'' $repeat:{2}' -f @(
            '15m', 'bump', '$true'
        )
        New-BurntToastNotification -Text "Starting: '$finalCmd'"
        Start-Process -path 'pwsh' -WindowStyle Hidden -ArgumentList @(
            '-Command'
            # "alarm -RelativeTimeString 1s -Message 'bump'"
            $finalCmd
        )


    }

    $state.SortUnique = {
        Get-Clipboard
        #| ForEach-Object { $_ -replace "'", '' }
        | Sort-Object -Unique
    }

}
catch {
    Write-Warning "funcDumpErrorOnLoad: $_"
}
function Invoke-MiniFuncDump {
    <#
    .synopsis
        1-liners or random one-offs not worth making a class
    .description
       .
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias('InvokeFuncDump')]
    [CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = 'InvokeCommand')]
    param(
        # todo: auto-generate completions using hashtable.
        [Alias('Name')]
        [Parameter(Position = 0,
            ParameterSetName = 'InvokeCommand'
        )]
        [ArgumentCompletions('HistoryFastPrint', 'ListMyCommands', 'Alarm_asBase64')]
        [string]$ScriptName,

        # list commands
        [parameter(ParameterSetName = 'ListOnly')]
        [switch]$List
    )

    begin {
    }
    process {
        $state = $script:__miniFuncDump

        if ($List -or (! $ScriptName)) {
            $state.keys
            return
        }

        if (! $State.ContainsKey($ScriptName)) {
            Write-Error -ea stop "No matching keys: '$_'"
            return
        }

        try {
            & $state[$ScriptName]
            return
        }
        catch {
            Write-Error "SBFailed: $_"
            return
        }


    }
    end {
    }
}

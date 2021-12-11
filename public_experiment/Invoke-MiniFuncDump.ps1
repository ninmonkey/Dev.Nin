$experimentToExport.function += @(
    'Invoke-MiniFuncDump'
)
$experimentToExport.alias += @(
    'InvokeFuncDump', 'idump'
)

try {
    $script:__miniFuncDump ??= @{}
    $state = $script:__miniFuncDump ?? @{}

    $state.HistoryFastPrint = {
        Get-History | Join-String -sep "`n`n$(hr)" -Property CommandLine
    }
    $state.MiniBitsConverter = {
        @'
    $a = '🥰d😀'
    [BitConverter]::ToString( [Text.UTF8Encoding]::new($false).getBytes($a)).replace('-', ' ')
'@ | bat -l ps1

        $a = '🥰d😀'
        [BitConverter]::ToString( [Text.UTF8Encoding]::new($false).getBytes($a)).replace('-', ' ')

    }
    $state.Pager_GetEnvVars = {
        Get-ChildItem env: | Where-Object Key -Match 'less|pager|bat' | Format-Table -AutoSize
        hr
        $regex = 'less|pager|bat|nin|dotfile|path|wsl|rg|ripgrep|gh|git'
        Get-ChildItem env: | Where-Object Key -Match $regex
        | Sort-Object key
        | Format-Table -AutoSize | rg ($regex + '|$')
        @'
# Env-Vars are all caps because some apps check for env vars case-sensitive
$Env:LESS ??= '-R'
$ENV:PAGER ??= 'bat'
$Env:PAGER ??= 'less -R' # check My_Github/CommandlineUtils for- better less args
$Env:PAGER ??= 'less' # todo: autodetect 'bat' or 'less', fallback  on 'git less'

# check the comments in the source:
# Get-Item function:\help | ForEach-Object ScriptBlock | code.cmd -
'@ | bat -l ps1 | Write-Information
    }
    $state.ListMyCommands = {
        '*filter->*', '*from->*', '*to->*' | ForEach-Object {
            Get-Command -m (_enumerateMyModule) $_
            hr
        }
        h1 'part 2 objects'
        Get-Command -m (_enumerateMyModule) *
        | Where-Object Name -Match (ReLit '->') # .Verb isn't returning all of the verbs
        | ForEach-Object {
            $verb, $noun = $_ -split (relit '->')
            [pscustomobject]@{
                PSTypeName = 'nin.minidump->customVerbInfo'
                Verb       = $verb
                Noun       = $noun
                Name       = $_
            }
        } | Tee-Object -var 'last'

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
    $state.Tree = {
        # using python lib 'rich', do a pretty tree
        $paths = @{
            venv   = Get-Item -ea stop 'c:/nin_temp/.venv'
            script = Get-Item -ea stop 'c:/nin_temp/tree.py'
        }
        $paths += @{
            toActivate = Get-Item -ea stop (Join-Path $paths.venv 'Scripts/Activate.ps1')
        }
        . $paths.toActivate
        . $paths.script (Get-Item .)
    }
    $state.ExportFolders = {
        $stream = @(
            Window->ExportFolders
            Get-Date | str prefix 'date: '
        )
        | str nl 1
        # | Add-Content "$Env:UserProfile\SkyDrive\Documents\2021\profile_dump\recent-folders.log"

        $stream | Add-Content "${Env:TempNin}\recent-folders.log"
        $stream | str hr -op "wrote:`n"
    }

    $state.SortUnique = {
        Get-Clipboard
        #| ForEach-Object { $_ -replace "'", '' }
        | Sort-Object -Unique
    }
    $state.Find_Pwsh_EncodedCommands = {
        <#
        .synopsis
            decode base64

        .notes
            See: Utility:
            [ArgumentCompleter([EncodingArgumentCompleter])]
            [EncodingArgumentConverter()]
            [Encoding] $Encoding
        .link
            Utility\
        #>
        $pwsh | Where-Object CommandLine -Match '\s+\-encodedCommand\s+' | ForEach-Object CommandLine
    }
    $state.Pwsh_ShowRunningArgs = {
        # [tip] using joinstring
        Get-Process pwsh | jstr -sep (hr 2) { $_.CommandLine -replace '\s-', "`n-" }
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
    [Alias(
        'InvokeFuncDump', 'iDump'
    )]
    [CmdletBinding(
        DefaultParameterSetName = 'InvokeCommand')]
    param(
        # todo: auto-generate completions using hashtable.
        [Alias('Name')]
        [Parameter(
            Mandatory, Position = 0,
            ParameterSetName = 'InvokeCommand'
        )]
        [ArgumentCompletions(
            'Tree', 'HistoryFastPrint', 'MiniBitsConverter', 'Pager_GetEnvVars',
            'ListMyCommands', 'Alarm_asBase64', 'ExportFolders'
        )]
        [string]$ScriptName,

        # don't run, dump the SB instead
        [parameter()]
        [switch]$GetScriptBlock,

        # list commands
        [parameter(ParameterSetName = 'ListOnly')]
        [switch]$List,

        # any  other params?
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [object[]]$ArgList
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
        if ($GetScriptBlock) {
            $state[$ScriptName]
            return
        }

        try {
            if ($ArgList) {
                throw 'double check args pass correctly'
            }
            # try  allowing arglist?
            # & $state[$ScriptName] @ArgList
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

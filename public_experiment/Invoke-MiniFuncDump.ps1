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
    $state.Find_Ps1Within2Weeks = {
        # find: newest 2weeks, by *.ps1, recurse
        fd --changed-within 2weeks -e ps1
        # sorted by lastwrite time
        | Sort-Object { $_ | Get-Item | ForEach-Object LastWriteTime }
        # normal tables, but don't group
        | Get-Item | Format-Table -group { $true }
    }
    $state.caeserCipher = {
        <#
        .synopsis
            more of a wierd array operator example


        .notes
            # kind of, not really.  https://en.wikipedia.org/wiki/Caesar_cipher

        #>

        $chars = 'a'..'f'
        $caeser_offset = 9
        foreach ($i in 0..($chars.Length - 1)) {
            @(
                $i + $caeser_offset
                $chars[$i]
            ) | Join-String -sep ' = '
            | ForEach-Object {
                $_.padLeft(8)
            }
        }
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

    $state.Get_MultilineHistory = {
        <#
        .synopsis
            filter to show multi-line commmands only
        .example
            PS> iDump Get_MultilineHistory # -ArgList @(ls . -File )
        .link
        #>
        param()
        Get-History
        | Where-Object { $_.CommandLine -match '\r?\n' }
        # now extra fancy
        | ForEach-Object CommandLine
        | Sort-Object -Unique
        | ForEach-Object { $_ -replace '\r?\n', "`n    " }
        | Join-StringStyle hr

    }

    $state.PsTypeNames_TypeDataDumpSummary = {
        <#
        .synopsis
            dump type info
        .example
            PS> iDump PsTypeNames_TypeDataDumpSummary -ArgList @(ls . -File )
        .link
            Get-TypeData
        .link
            about_Types.ps1xml
        .link
            https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_types.ps1xml?view=powershell-7.3

        #>
        function _getTypeData {
            param($InputObject)

            $src = $InputObject
            $td = @{}

            $tnames = $src.pstypenames
            $tnames | ForEach-Object {
                $td[$_] = Get-TypeData -TypeName $_

            }

            $td.GetEnumerator() | ForEach-Object {
                h1 $_.Key
                $_.Value | s * | Format-List *

                label 'member' 'default display property set'
                $_
            }
            $td.members.keys
            | str csv ' ' | label 'TD.members.keys'

            $td | ForEach-Object defaultdisplaypropertyset
            | str csv ' ' | label 'TD.DefaultDisplayPropertySet'

            $td | ForEach-Object defaultdisplaypropertyset | ForEach-Object ReferencedProperties
            | str csv ' ' | label 'TD.DefaultDisplayPropertySet.ReferencedProperties'



        }
        $source = $args
        $source ??= Get-Item .
        $source
        | Get-Unique -OnType
        | ForEach-Object {
            $source = $_
            Label 'item' $source
            _getTypeData -InputObject $source


        }
        # $src = ($args[0] ?? $args) ?? (Get-Item .)

    }

} catch {
    Write-Warning "funcDumpErrorOnLoad: $_"
    throw "funcDumpErrorOnLoad: $_"
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
            'Find_Ps1Within2Weeks',
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
                Write-Warning 'double check args pass correctly'
            }
            # try  allowing arglist?
            # & $state[$ScriptName] @ArgList
            & $state[$ScriptName] @ArgList
            return
        } catch {
            Write-Error "SBFailed: $_"
            return
        }


    }
    end {
    }
}

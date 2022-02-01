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
    $state.Find_ResolveQualifiedCommands = {
        Get-Command -Module (_enumerateMyModule) -ea ignore | Sort-Object Name | Where-Object Name -Match '->'
        | resCmd -q -ea ignore | ForEach-Object Name | Sort-Object -Unique
        | obj | Format-Wide -AutoSize
    }
    $state.Find_DevNinVerbUsage_UsingMappedColors = {
        $g = iDump Find_DevNinVerbUsage_Group
        $g.Group | ForEach-Object {
            $cmd = $_
            $mappedColor = $color_for_devnin = $ColorMapping | Where-Object { $_.ModuleName -eq $cmd.Module.Name } | ForEach-Object color
            @(
                $cmd.Name | write-color $mappedColor

                $cmd.Module.Name | write-color gray50
            ) | Join-String

        } | str hr

        hr

        $g = iDump Find_DevNinVerbUsage_Group
        $g.Group | Sort-Object Name | ForEach-Object {
            $cmd = $_
            $mappedColor = $color_for_devnin = $ColorMapping | Where-Object { $_.ModuleName -eq $cmd.Module.Name } | ForEach-Object color
            @(
                $cmd.Name | write-color $mappedColor
                ' '
                $cmd.Module.Name | write-color gray50
            ) | Join-String

        } | str nl | Sort-Object
    }
    $state.Find_DevNinVerbUsage_colorsMapping = {

        function _colorsMapping {
            $Map = @{
                ModuleNames = $g.group.source | Sort-Object -Unique
            }

            $grads = Get-Gradient -StartColor orange -EndColor blue -Width ($Map.ModuleNames.count)
            #$Map += @{
            #
            #}
            $ColorMapping
            $Map | Format-Table -AutoSize # Format-HashTable

            $ColorMapping = 0..($Map.ModuleNames.count - 1) | ForEach-Object {
                [pscustomobject]@{
                    ModuleName = $Map.ModuleNames[ $_ ]
                    Color      = $grads[ $_ ]
                }

                #    @{   Module = $Map.ModuleNames[ $_ ] ;
                #     $Map.gr
            }
            $ColorMapping
            #[hashtable]$NameToColor = $Map.ModuleNames
            # example use
            #$color_for_devnin = $ColorMapping | ? ModuleName -eq 'dev.nin' |  % color

        }
        _colorsMapping
    }
    $state.Find_DevNinVerbUsage_GroupSummary = {
        $sbGroupOn = { $_ -split '->' | Select-Object -First 1 }
        $g =
        Get-Command -Module (_enumerateMyModule) | Sort-Object Name | Where-Object Name -Match '->'
        | Group-Object $sbGroupOn
        | Sort-Object Count -Descending
        $g | ForEach-Object {
            $cur = $_
            $cur.Group.Name -replace '^.*->', ''
            # as array
            | str csv -Unique ' ' | Join-String -op '{ ' -os ' }'
        }
    }
    $state.Find_DevNinVerbUsage_Group = {
        $sbGroupOn = { $_ -split '->' | Select-Object -First 1 }
        Get-Command -Module (_enumerateMyModule) | Sort-Object Name | Where-Object Name -Match '->'
        | Group-Object $sbGroupOn
        | Sort-Object Count -Descending
    }
    $state.Find_DevNinVerbUsage_Count = {
        function _find-DevNinVerbUsage {
            # super inefficient
            Get-Command -Module (_enumerateMyModule) | Sort-Object Name | Where-Object Name -Match '->'
            | ForEach-Object { $_ -split '->' | Select-Object -First 1 } | Group-Object -NoElement | Sort-Object Count -Descending
        }
        _find-DevNinVerbUsage
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
        # | Add-Content \"$Env:UserProfile\SkyDrive\Documents\2021\profile_dump\recent-folders.log"

        $stream | Add-Content "${Env:TempNin}\recent-folders.log"
        $stream | str hr -op "wrote:`n"
    }

    $state.FindPBIX_Instance = {
        @'
    See:
        See also: https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/file-system/how-to-get-information-about-files-folders-and-drives

    handles from file:
        https://www.codeproject.com/Articles/18975/Listing-Used-Files
'@
        $pbi = Get-Process '*msmdsrv*'
        $pbix | ForEach-Object {
            $curPs = $_
            $curPS | s Path, CommandLine, MainModule, *path*, *file* -ea ignore
            | Format-List

            ($curPS).CommandLine -replace '^.*\-n\s+' -replace '\s+-s\s+.*$'

        }
    }
    $state.LoremIpsum_HexColumn = {
        <#
        .synopsis
            silly auto-wrapping text experiment
        .example
            PS>
            efc5da  2bcea7  1ae5df  562389  70d6b4
            3520eb  4651d7  4f312d  c27b0f  17d963
            7be6c3  dbe384  940bd7  e47dc9  a1d64c
        #>

        RepeatIt 105 {
            $alphaHex = 'a'..'f' + 0..9
            $alphaHex | Get-Random -Count 6
            | str str '' #-op '0x'
        }
        | obj | Format-Wide -AutoSize


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
    $state.FindAllNamespaces = {
        <#
            .synopsis
                Similar  to find-namespace
            .link
                ClassExplorer\Find-Namespace
        #>

        & {
            $search1 = Find-Namespace | ForEach-Object FullName | Sort-Object -Unique
            $search2 = Find-Type | ForEach-Object Namespace | Sort-Object -Unique

            $queries = $search1, $search2 | Sort-Object { $_.Count } -Descending
            $delta = $queries[0] | Where-Object {
                $_ -notin $queries[1]
            }

            $delta | str ul
            $delta | len | label 'Delta'
            $search1 | len | Label 'Find-Namespace'
            $search2 | len | Label 'Find-Type'
            'Missing values, grouped on root'
            $delta | Group-Object { $_ -split '\.' | Select-Object -First 1 }

        }

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
    $state.Table_GroupByMonth = {
        <#
        .synopsis
            filter to show multi-line commmands only
        .example
            PS> $files = ls .
            PS> iDump Table_GroupByDay -Arg $Files
        .link
        #>
        param(
            # $Args
        )
        $InputObject = Get-ChildItem . -Recurse

        $tableByMonth = {
            $when = $_.LastWriteTime
            $when.Year, $when.Month
        }

        $InputObject
        | Sort-Object LastWriteTime
        | Format-Table -GroupBy $tableByMonth



    }
    $state.Table_GroupByDay_iter0 = {
        <#
        .synopsis
            filter to show multi-line commmands only
        .example
            PS> $files = ls .
            PS> iDump Table_GroupByDay -Arg $Files
        .link
        #>
        param(
            # $Args
        )
        $InputObject = Get-ChildItem . -Recurse

        $tableByDay = {
            $when = $_.LastWriteTime
            $when.Year, $when.Month, $When.Day
        }

        $InputObject
        | Sort-Object LastWriteTime
        | Format-Table -GroupBy $TableByDay
    }
    $state.Table_GroupByDay = {
        <#
        .synopsis
            fixed calculate property for tables, vs version: iter0
        .example
            PS> iDump Table_GroupByDay -Arg '.'

        .link
        #>
        param(
            [string]$Path
        )
        $Path ??= '.'
        $SbGroupByDay = @{
            Name       = 'When'
            Expression = {
                $when = $_.LastWriteTime
                $when.Year, $when.Month, $When.Day
            }
        }

        $InputObject = Get-ChildItem $Path -Depth 2
        $InputObject | Sort-Object LastWriteTime
        | Format-Table -GroupBy $SBTableGroupProp

        # Get-ChildItem . | Sort-Object LastWriteTime -des
        # | f 50
        # | Format-Table -GroupBy $SbByDay
        # #        | Format-Table -GroupBy @{
        # ## name = 'when'
        # #expression =  { $_.LastWriteTIme }
        # #}#

        # $InputObject
        # | Sort-Object $tableByDay
        # | f 50
        # | Format-Table -GroupBy @{
        #     name       = 'when'
        #     expression = { $_.LastWriteTIme }
        # }
    }
    $state.Get_NinVerbs = {
        <#
        .synopsis
            find nin-verbs using the delim '->'
        .example
            .
        .link
        #>
        param(
            # $Args
        )

        Get-Command -m (_enumerateMyModule)
        | Where-Object name -Match '->' | Sort-Object Name
        | ForEach-Object { $_ -split '->' | Select-Object -First 1 } | Sort-Object -Unique

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

    $state.Command_DumpInfoPretty = {
        # future, is the non-passhtru version
        # $dbg = [ordered]@{
        $dbg = [pscustomobject]@{
            'relPSCommandPath'               = $PSCommandPath | To->RelativePath
            'relPSScriptRoot'                = $PSScriptRoot | To->RelativePath
            'PSBoundParameters'              = $PSBoundParameters
            'PSCmdlet'                       = $PSCmdlet
            'PSCommand'                      = $PSCommand
            'PSCommandPath'                  = $PSCommandPath | Get-Item
            'PSDefaultParameterValues'       = $PSDefaultParameterValues
            'psEditor'                       = $psEditor
            'PSNativeCommandArgumentPassing' = $PSNativeCommandArgumentPassing
            'PSScriptRoot'                   = $PSScriptRoot | Get-Item
        }

        h1 'Top'
        $dbg | Format-List

        h1 'PSDefaultParameterValues'
        $dbg.PSDefaultParameterValues | Sort-Hashtable -SortBy Key | format-dict

    }
    $state.Command_DumpInfo = {
        # $dbg = [ordered]@{
        $dbg = [pscustomobject]@{
            'relPSCommandPath'               = $PSCommandPath | To->RelativePath
            'relPSScriptRoot'                = $PSScriptRoot | To->RelativePath
            'PSBoundParameters'              = $PSBoundParameters
            'PSCmdlet'                       = $PSCmdlet
            'PSCommand'                      = $PSCommand
            'PSCommandPath'                  = $PSCommandPath | Get-Item
            'PSDefaultParameterValues'       = $PSDefaultParameterValues
            'psEditor'                       = $psEditor
            'PSNativeCommandArgumentPassing' = $PSNativeCommandArgumentPassing
            'PSScriptRoot'                   = $PSScriptRoot | Get-Item
        }
        $dbg

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
    $state.Color_DumpAnimatedAnsiFW = {
        h1 'basic'
        $i = 0
        RepeatIt 3 {
            $i++
            Get-ColorWheel -Count 100 -HueStep 56
            | _write-AnsiBlock -NoName | obj | Format-Wide -AutoSize ##(30 + $i)
        }
        hr -fg magenta
        h1 'more involved'
        $maxLoops = 3 ; $loopCount = 0
        $hueStep = Get-Random -Maximum 120 -Minimum 0
        $wheelSteps = Get-Random -Maximum 300 -Minimum 100
        $sleep = 0.1

        while ($loopCount++ -lt $maxLoops) {
            #  h1 $loopCount

            Get-ColorWheel -Count $wheelSteps -HueStep $hueStep
            | _write-AnsiBlock -NoName | obj | Format-Wide -AutoSize

            $loopCount++; Start-Sleep $sleep
        }
    }
    $state.Color_DumpAnsiFw = {
        Get-ChildItem fg:\
        | _write-AnsiBlock -NoName | obj | Format-Wide -AutoSize
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
    .notes
        - [ ] todo #6 refactor to microfunctions that don't have to be declared strangely ? or just a wrapper for the current args
        - [ ] could add -UseInputFromPipeline option
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
            'Alarm_asBackground_iter0', 'Alarm_asBase64', 'caeserCipher', 'Color_DumpAnimatedAnsiFW', 'Color_DumpAnsiFw', 'Command_DumpInfo', 'Command_DumpInfoPretty', 'ExportFolders', 'Find_DevNinVerbUsage_Count', 'Find_DevNinVerbUsage_Group', 'Find_DevNinVerbUsage_GroupSummary', 'Find_Ps1Within2Weeks', 'Find_Pwsh_EncodedCommands', 'Find_ResolveQualifiedCommands', 'FindAllNamespaces', 'FindPBIX_Instance', 'Get_MultilineHistory', 'Get_NinVerbs', 'HistoryFastPrint', 'ListMyCommands', 'LoremIpsum_HexColumn', 'MiniBitsConverter', 'Pager_GetEnvVars', 'PsTypeNames_TypeDataDumpSummary', 'Pwsh_ShowRunningArgs', 'SortUnique', 'Table_GroupByDay', 'Table_GroupByDay_iter0', 'Table_GroupByMonth', 'Tree'
            # 'Tree', 'HistoryFastPrint', 'MiniBitsConverter', 'Pager_GetEnvVars',
            # 'Find_Ps1Within2Weeks',
            # 'ListMyCommands', 'Alarm_asBase64', 'ExportFolders', 'FindPBIX_Instance'
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
            $state.keys | Sort-Object -Unique
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
        if ($List) {
            Write-Warning 'future:
            [1] make all names ArgumentCompletions, automatically
            [2] completer **tooltips** show the __doc__ str for that function.
        '
        }
    }
}

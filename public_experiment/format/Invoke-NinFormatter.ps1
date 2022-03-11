#Requires -Version 7
#Requires -Module PSScriptAnalyzer
# using namespace Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-NinFormatter'
    )
    $experimentToExport.alias += @(
        'fmt->FormatCode'
    )
}

function Invoke-NinFormatter {
    <#
    .synopsis
        Automatically format using user's custom rules, from the cli
    .description
       .
    .example
        # formats and saves file
          PS> Invoke-NinFormatter -Path 'c:\foo\bar.ps1' -WriteBack
    .notes
        future: allow piping from:
            [HistoryInfo] | [Microsoft.PowerShell.PSConsoleReadLine+HistoryItem]
    .link
        PSScriptAnalyzer\Invoke-Formatter
    .link
        Ninmonkey.Console\Invoke-FormatterFancy
    .link
        Dev.Nin\Invoke-Formatter
    .outputs
          [string] or [string[]]

    #>
    [CmdletBinding(
        # DefaultParameterSetName = 'FromPipeOrParam'
    )]
    param(

        # # pipe script contents
        # # Must allow null for piping split text
        [cmdletbinding(DefaultParameterSetName = 'FromParam')]
        [Alias('InputObject')]
        [AllowEmptyString()]
        [AllowNull()]
        # [Parameter(
        #     ParameterSetName = 'FromParam',
        #     Mandatory, Position = 0
        # )]
        # [Parameter(
        #     ParameterSetName = 'FromPipeline',
        #     Mandatory, ValueFromPipeline
        # )]
        [Parameter(
            Mandatory, Position = 0, ValueFromPipeline
        )]
        [string[]]$ScriptDefinition,

        # # modify file in place
        # [alias('InputFile')]
        # [Parameter(
        #     Mandatory, ParameterSetName = 'FromFile'
        # )]
        # [string]$Path,

        # What's the current config?
        [Parameter(ParameterSetName = 'GetConfig')]
        [switch]$GetConfig

        # # replace original file with formatting
        # [Parameter(ParameterSetName = 'FromFile')]
        # [switch]$WriteBack,

        # # Formats Last Command in history
        # # [Alias('FromLastCommand', 'PrevCommand', 'FromHistory')]
        # [Alias('PrevCommand')]
        # [Parameter(
        #     Mandatory,
        #     ParameterSetName = 'FromHistory'

        # )][switch]$LastCommand,

        # # Formats Last Command in history
        # [Alias('FromClipboard')]
        # [Parameter(
        #     Mandatory,
        #     ParameterSetName = 'FromClipboard'
        # )][switch]$Clipboard

    )

    begin {

        # switch ($PSCmdlet.ParameterSetName) {
        #     'FromPipeline' {

        #         break
        #     }
        #     'FromParam' {
        #         break
        #     }

        #     default {
        #         Write-Error -ea stop -Category NotImplemented -Message 'Unhandled ParameterSet' -TargetObject $PSCmdlet.ParameterSetName
        #     }
        # }

    }
    process {
        # switch ($PSCmdlet.ParameterSetName) {
        #     'FromPipeline' {

        #         break
        #     }
        #     'FromParam' {
        #         break
        #     }

        #     default {
        #         Write-Error -ea stop -Category NotImplemented -Message 'Unhandled ParameterSet' -TargetObject $PSCmdlet.ParameterSetName
        #         # throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
        #     }
        # }
    }
    end {
        $FinalText = $ScriptDefinition | Join-String -sep "`n"
        $invokeFormatterSplat = @{
            ScriptDefinition = $FinalText -join "`n"
            # Settings = 'settings'
            # Range = 3, 4
        }
        # Wait-Debugger

        # Write-Warning 'wip: formatting - rewrite'
        Invoke-Formatter @invokeFormatterSplat
        #  ; return;


        if ($false) {
            $ScriptDefinition | Endcap🎨 Bold 'ScriptDef'
            $FinalText | Endcap🎨 Bold 'FinalText'
        }

        # Wait-Debugger
        # return
        $invokeFormatterSplat = @{
            ScriptDefinition = $FinalText #$scriptContent -join "`n"
            # formatter requires path, while Invoke-ScriptAnalyzer doe
            Settings         = try {
(Get-Item -ea stop $__ninConfig.Config.PSScriptAnalyzerSettings)?.FullName
            } catch {
                Write-Error -m (
                    'Error loading: $__ninConfig.Config.PSScriptAnalyzerSettings = "{0}"' -f @(
                        $__ninConfig.Config.PSScriptAnalyzerSettings
                    )
                )

            }
        }
        'using: $__ninConfig.Config.PSScriptAnalyzerSettings = "{0}"' -f @(
            $__ninConfig.Config.PSScriptAnalyzerSettings
        ) | Write-Debug

        if ($GetConfig) {
            [PSCustomObject]@{
                Settings   = Get-Content $invokeFormatterSplat.Settings
                Path       = $invokeFormatterSplat.Settings
                EnvVarPath = $__ninConfig.Config.PSScriptAnalyzerSettings
            }

            $x = 9
            # Wait-Debugger
            return
        }

        $invokeFormatterSplat | Format-dict | Write-Debug
        Invoke-Formatter @invokeFormatterSplat

        # try {}

        # if ($WriteBack) {
        #     if ($PSCmdlet.ShouldProcess("$($Path.Name)", 'Replace')) {
        #         Invoke-Formatter @invokeFormatterSplat | Set-Content $Path
        #         return
        #     }
        # }
        # Invoke-Formatter @invokeFormatterSplat # -Range
    }
}


if (! $experimentToExport) {
    # ...
}

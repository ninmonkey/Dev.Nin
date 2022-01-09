

# requires -version 5
using namespace System.Management.Automation
using namespace System.Management.Automation.Language


if ( $PSRL_experimentToExport ) {
    # $PSRL_experimentToExport.alias += @(
    #     # 'A'
    # )
    $PSRL_experimentToExport.PSReadLineKeyHandler += @(
        # 'dev.Invoke-JmGitCommand'

        # Stolen and modified from https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1

        throw 'ever getting invoked?'
        { throw 'ever getting invoked?' }

        {
            Set-PSReadLineKeyHandler -Key F4 `
                -BriefDescription 'CommandHelp' `
                -LongDescription 'Open the help window for the current command. future: work on types' `
                -ScriptBlock {
                param($key, $arg)

                $ast = $null
                $tokens = $null
                $errors = $null
                $cursor = $null
                [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

                $commandAst = $ast.FindAll( {
                        $node = $args[0]
                        $node -is [CommandAst] -and
                        $node.Extent.StartOffset -le $cursor -and
                        $node.Extent.EndOffset -ge $cursor
                    }, $true) | Select-Object -Last 1

                if ($commandAst -ne $null) {
                    $commandName = $commandAst.GetCommandName()
                    if ($commandName -ne $null) {
                        $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
                        if ($command -is [Management.Automation.AliasInfo]) {
                            $commandName = $command.ResolvedCommandName
                        }

                        if ($commandName -ne $null) {
                            #First try online
                            try {
                                Get-Help $commandName -Online -ErrorAction Stop
                            } catch [InvalidOperationException] {
                                if ($PSItem -notmatch 'The online version of this Help topic cannot be displayed') { throw }
                                Get-Help $CommandName -ShowWindow
                            }
                        }
                    }
                }
            }

        }
    )
}

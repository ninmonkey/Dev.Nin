#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_write-GitDefaultPromptStatus'
    )
    $experimentToExport.alias += @(
        'Find->MyGitDir'
    )
}

Set-Alias 'Find->MyGitDir' -Value 'posh-git\Get-GitDirectory' -Description 'shorthand to find your current repo'

function _write-GitDefaultPromptStatus {
    <#
    .synopsis
        taken from PoshGit
    .description
        Original source, you can generate it from

           $GitPromptScriptBlock | Set-ClipBoard
    .notes
        see also

            PS> $GitPromptSettings

                # info dump

        and see also:

            PS> gcm get-promptpath |  % ScriptBlock | bat -l ps1

        and see also:

            PS> Get-Variable git* | % Name

                'GitMissing'
                'GitPromptScriptBlock'
                'GitPromptSettings'
                'GitPromptValues'
                'GitStatus'
                'GitTabSettings'

    #>

    $origDollarQuestion = $global:?
    $origLastExitCode = $global:LASTEXITCODE

    if (!$global:GitPromptValues) {
        $global:GitPromptValues = [PoshGitPromptValues]::new()
    }

    $global:GitPromptValues.DollarQuestion = $origDollarQuestion
    $global:GitPromptValues.LastExitCode = $origLastExitCode
    $global:GitPromptValues.IsAdmin = $IsAdmin

    $settings = $global:GitPromptSettings

    if (!$settings) {
        return "<`$GitPromptSettings not found> "
    }

    if ($settings.DefaultPromptEnableTiming) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
    }

    if ($settings.SetEnvColumns) {
        # Set COLUMNS so git knows how wide the terminal is
        $Env:COLUMNS = $Host.UI.RawUI.WindowSize.Width
    }

    # Construct/write the prompt text
    $prompt = ''

    # Write default prompt prefix
    $prompt += Write-Prompt $settings.DefaultPromptPrefix.Expand()

    # Get the current path - formatted correctly
    $promptPath = $settings.DefaultPromptPath.Expand()

    # Write the delimited path and Git status summary information
    if ($settings.DefaultPromptWriteStatusFirst) {
        $prompt += Write-VcsStatus
        $prompt += Write-Prompt $settings.BeforePath.Expand()
        $prompt += Write-Prompt $promptPath
        $prompt += Write-Prompt $settings.AfterPath.Expand()
    } else {
        $prompt += Write-Prompt $settings.BeforePath.Expand()
        $prompt += Write-Prompt $promptPath
        $prompt += Write-Prompt $settings.AfterPath.Expand()
        $prompt += Write-VcsStatus
    }

    # Write default prompt before suffix text
    $prompt += Write-Prompt $settings.DefaultPromptBeforeSuffix.Expand()

    # If stopped in the debugger, the prompt needs to indicate that by writing default propmt debug
    if ((Test-Path Variable:/PSDebugContext) -or [runspace]::DefaultRunspace.Debugger.InBreakpoint) {
        $prompt += Write-Prompt $settings.DefaultPromptDebug.Expand()
    }

    # Get the prompt suffix text
    $promptSuffix = $settings.DefaultPromptSuffix.Expand()

    # When using Write-Host, we return a single space from this function to prevent PowerShell from displaying "PS>"
    # So to avoid two spaces at the end of the suffix, remove one here if it exists
    if (!$settings.AnsiConsole -and $promptSuffix.Text.EndsWith(' ')) {
        $promptSuffix.Text = $promptSuffix.Text.Substring(0, $promptSuffix.Text.Length - 1)
    }

    # This has to be *after* the call to Write-VcsStatus, which populates $global:GitStatus
    # Set-WindowTitle $global:GitStatus $IsAdmin

    # If prompt timing enabled, write elapsed milliseconds
    if ($settings.DefaultPromptEnableTiming) {
        $timingInfo = [PoshGitTextSpan]::new($settings.DefaultPromptTimingFormat)
        $sw.Stop()
        $timingInfo.Text = $timingInfo.Text -f $sw.ElapsedMilliseconds
        $prompt += Write-Prompt $timingInfo
    }

    $prompt += Write-Prompt $promptSuffix

    # When using Write-Host, return at least a space to avoid "PS>" being unexpectedly displayed
    if (!$settings.AnsiConsole) {
        $prompt += ' '
    } else {
        # If using ANSI, set this global to help debug ANSI issues
        $global:GitPromptValues.LastPrompt = EscapeAnsiString $prompt
    }

    $global:LASTEXITCODE = $origLastExitCode
    $prompt

}

if (! $experimentToExport) {
    # ...
}

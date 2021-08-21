$experimentToExport.function += 'Get-PwshVsCodeEnvInfo'
$experimentToExport.alias += 'Collect-VSCodeEnv'

function Get-PwshVsCodeEnvInfo {
    # grab several version numbers

    [Alias('Collect-VSCodeEnv')]
    [cmdletbinding()]
    param()

    @"

$(_Write-VerboseDebugPrompt)
vscode-Powershell-preview: 2021.8.1
Pwsh Version: $($PSVersionTable.PSVersion)
PSReadLine: $(Get-Module PSReadLine | ForEach-Object Version)
"@ | pygmentize.exe -l yaml
    Get-Module psreadline # | Out-String)
    "`n"
}

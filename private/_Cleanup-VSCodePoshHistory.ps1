<#
. 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\InvokePesterStub.ps1'
#>

function _Test-IsVSCodePoshHistory {
    <#
    .synopsis
        return true of command (probably) was spam from VS Code execute

    idea:

        Because 'launch.json' fires causes execution,
            parse it and look for a match

        example:
            '$Env:UserProfile\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\InvokePesterStub.ps1'

        came from:
                        {
                    "name": "🐛🐜TaskTest",
                    "type": "PowerShell",
                    "request": "launch",
                    "script": "Invoke-pester",
                    "args": [
                        "-Path 'public\\ConvertTo-VariablePath.tests.ps1'",
                    ],
                    "cwd": "${workspaceFolder}"
                },
    .link
        _cleanupVSCodePoshHistory
    #>
    # [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', 'Experiment', Scope='Function', Target='*')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Single History line
        [Alias('Text')]
        [Parameter(Mandatory, Position=0, ValueFromPipeline)]
        [string]$InputText
    )
    begin {
        $Patterns = @(
            @{
                Label   = 'VS Code: Invoke Pester from CodeLens'
                Pattern = [Regex]::Escape( @"
. '$Env:USERPROFILE\.vscode\extension'
"@ )
            }
            # '. 'c:\Users\cppmo_000\.vscode\extensions\'
        )
    }

    process {
        return $False
    }
    # $Patterns

}

function _cleanupVSCodePoshHistory {
    <#
    .synopsis
        remove 'spam' entered from running debug
    .notes
        sample cases to filter

            . 'c:\Users\cppmo_000\.vscode\extensions\ms-vscode.powershell-preview-2020.9.0\InvokePesterStub.ps1'
    .link
        _Test-IsVSCodePoshHistory
    #>


}

# _cleanupVSCodePoshHistory

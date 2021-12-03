#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Set-VSCodeVenvOption'
        'Get-VSCodeVenvOption'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}


class VSCodeVenvOption {
    [string]$DefaultBinPath
    [string]$DefaultDataDir
    [string]$DefaultExtensionDir
}
# code.cmd --user-data-dir 'J:\vscode_datadir\code-dev\'  --extensions-dir 'J:\vscode_datadir\code-dev-addons\' -m '.' #-n -g -

#  | To->Json | From->Json

function Set-VSCodeVenvOption {
    <#
    .synopsis
        quick hack: save metadat
    .notes
        future could be one command
            venv-config <set|get> [key] [value]
    .example
        Set-VSCodeVenvOption @{DefaultBinPath='code-insiders.cmd'}

    #>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$ConfigOption
    )


    [VSCodeVenvOption]$curConfig = Get-VSCodeVenvOption
    $curConfig | Format-Table | Out-String
    # | str prefix 'prev config'
    | Write-Debug

    $validKeys = @('DefaultBinPath', 'DefaultDataDir', 'DefaultExtensionDir')
    # or
    # $ValidKeys = $curConfig | Iter->PropName

    $ConfigOption.GetEnumerator() | ForEach-Object {
        $Key = $_.Key ; $Value = $_.Value
        if ($Key -notin $validKeys ) {
            Write-Error "Invalid KeyName: '$Key'. Expected: $($validKeys -join ', ' )"
            return
        }
        $curConfig.$Key = $Value
    }


    $curConfig | Format-Table | Out-String
    # | str prefix 'new config'
    | Write-Debug


}
function Get-VSCodeVenvOption {
    <#
    .synopsis
        quick hack: save metadat
    #>
    [OutputType([VSCodeVenvOption])]
    [cmdletbinding()]
    param()

    [VSCodeVenvOption]@{
        DefaultBinPath      = 'code.cmd'
        DefaultDataDir      = 'J:\vscode_datadir\code-dev\'
        DefaultExtensionDir = 'J:\vscode_datadir\code-dev-addons\'
    }
}

Write-Warning 'need: abstract, minimal, nested config class for arbitrary data to json store'

if (! $experimentToExport) {
    # ...

    # ls .
}

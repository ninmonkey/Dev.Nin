#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_Completions-BatTheme'
    )
    $experimentToExport.alias += @(
        'Completions->CmdBatTheme'
    )
}


function _Completions-BatTheme {
    <#
    .synopsis
        Enumerate themes for 'Bat'
    .link
        Dev.Nin\Out-Bat
    .notes
        themes are case-sensitive
    .example
        PS> Completions->CmdBatTheme

        'Nord', 'zenburn', 'Github', 'Dracula', 'TwoDark'
    #>

    [Alias('Completions->CmdBatTheme')]
    [CmdletBinding()]
    param()

    $binBat = Get-NativeCommand 'bat' -ea stop
    & $binBat @('--list-themes')
    | Out-Host # required to redirect to success stream, it has non-default behavior
    | Where-Object { $_.tostring() -Match 'Theme' } | Sort-Object -Unique
}

if (! $experimentToExport) {
    # ...
}

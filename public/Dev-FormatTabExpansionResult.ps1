function Dev-FormatTabExpansionResult {
    <#
    .synopsis
        formats results from tab completion
    .example
        PS> Dev-FormatTabExpansionResult 'ls ' 1
        | % CompletionMatches | fl
    .#>
    [alias('FormatTab')]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = 'script to run')]
        [string]$Command,

        [Parameter(Mandatory, Position = 1, HelpMessage = 'cursor?')]
        [int]$CursorColumn = 0
    )
    TabExpansion2 -inputScript $Command -cursorColumn $CursorColumn
}
<#
example 1 returns files
Dev-FormatTabExpansionResult 'ls . -f' 1
#>
if ($False) {
    0..3 | ForEach-Object {
        $CurColumn = $_
        $result = Dev-FormatTabExpansionResult 'ls . -f' -CursorColumn $CurColumn
        $result | Format-Table
        $x = 1 + 34
        $CompleterMatch = $result | Select-Object -ExpandProperty 'CompletionMatches' | Tee-Object -var 'LastCompleterMatch'
        $CompleterMatch
    }
}
$experimentToExport.function += 'ConvertTo-RegexLiteral'
$experimentToExport.alias += 'ReLit', 'ReLiteral'

function ConvertTo-RegexLiteral {
    <#
    .synopsis
        sugar to quickly escape values to thier regex-literal
    .description
        .example
        $PS> re 'something'
    .example
        $pattern = re 'something' -AsRipGrep
        rg @('-i', $Pattern)
    .notes
        variants notes verses default [regex]::escape behavior
            see more in 'ConvertTo-RegexLiteral.tests.ps1'

        powershell
            - do; or do not escape ' ' is okay

        vs code / javascript
            - do not escape '#'
            - do not escape ' '
            - must escape '}'

        ripgrep
            - do not escape ' '
                or else escape the '\' before it


    .outputs

    #>
    [alias('ReLit', 'ReLiteral')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Text to convert to a literal
        [Alias('InputObject')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$Text,

        # Use Regex literal format for ripgrep (ie: Rust Lang)
        [Parameter()][switch]$AsRipgrepPattern,

        # Use Regex literal format for ripgrep (ie: Rust Lang)
        [Parameter()][switch]$AsVSCode
    )
    begin {}
    process {
        $Text | ForEach-Object {
            if ((! $AsRipgrepPattern) -and (! $AsVSCode)) {
                [regex]::Escape($_)
            }
            elseif ($AsRipgrepPattern) {
                [regex]::Escape($_) -replace
                '\\ ', ' '
            }
            elseif ($AsVSCode) {
                [regex]::Escape($_) -replace
                '\\ ', ' ' -replace
                '\\#', '#' -replace
                '}', '\}'
            }
        }
    }
    end {}
}

#Requires -Version 7.0.0
$experimentToExport.function += 'ConvertTo-PwshLiteral'
# $experimentToExport.alias += 'FindDotfile'

function ConvertTo-PwshLiteral {
    <#
    .synopsis
        convert [string] to a paste-able Pwsh 7 text literal
    .description
        Desc
    .example
        PS> $sample = '🐒‍Business'
            "`u{1f412}`u{200d}`u{42}`u{75}`u{73}`u{69}`u{6e}`u{65}`u{73}`u{73}"

            Notice the ZWJ char between Monkey and "B"
    .outputs
        [string]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Input as a string
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [String]$InputText
    )

    begin {
        $Template = @{}
        $Template.SingleRune = @(
            "``u{{"
            '{0:x}'
            '}}'
        ) | Join-String
    }
    process {

        $InputText.EnumerateRunes() | Join-String {
            $Template.SingleRune -f $_.Value
        } -sep '' -op "`"" -os "`""
    }
    end {}
}

$experimentToExport.function += 'New-RegexEitherOrder'
$experimentToExport.alias += 'RegexEitherOrder'

function New-RegexEitherOrder {
    <#
    .synopsis
        Combine patterns, creating a new OR regex pattern
    .description

        mainly used in vs code

    .example
            🐒>  ...
        [string]

    #>
    [Alias('RegexEitherOrder')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # regex
        [Alias('A')]
        [Parameter(Mandatory, Position = 0)]
        [string]$RegexA,
        # regex
        [Alias('B')]
        [Parameter(Mandatory, Position = 1)]
        [string]$RegexB,

        # Verbose
        [Parameter()][switch]$RegexVerbose
    )

    begin {
        $splat_JoinLiteralOr = @{
            Separator = '|'
            Property  = { '({0})' -f [regex]::Escape( $_) }
        }
        $splat_JoinRegexOr = @{
            Separator = '|'
            Property  = { '({0})' -f $_ }
        }

        $Template = @{}
        $Template.PartA = '(({0}).*({1}))'
        $Template.PartB = '(({1}).*({0}))'
        $Template.Basic = @(
            $Template.PartA
            $Template.PartB
        ) | Join-String @splat_JoinRegexOr

        $Template.Verbose = @'
(?x)
# Case1: Basic
(
    # Regex: A
    ({0})
    .*
    # Regex: B
    ({1})
)
|
(
    # Regex: B
    ({1})
    .*
    # Regex: A
    ({0})
)
'@
    }
    process {
        # todo": simplify: refactor using Join-Regex

        $Template = ($RegexVerbose) ? $Template.Verbose : $Template.Basic
        $FinalRegex = $Template -f @($RegexA, $RegexB)
        Write-Debug "Regex A = '$RegexA'"
        Write-Debug "Regex B = '$RegexB'"
        Write-Debug "Regex Template: '$($template)'"
        Write-Debug "Final Regex: '$($FinalRegex)'"
        $FinalRegex
    }
    end {}
}

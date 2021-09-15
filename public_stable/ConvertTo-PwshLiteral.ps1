#Requires -Version 7.0.0
if (! $DebugInlineToggle) {
    $stableToExport.function += 'ConvertTo-PwshLiteral'
    # $stableToExport.alias += ''
}

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
        [String]$InputText,

        # leave ascii codepoints as literals
        [switch]$PreserveAscii
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
            if ($PreserveAscii -and $_.Value -le 127) {
                $_ ; return
            }

            $Template.SingleRune -f $_.Value
        } -sep '' -op "`"" -os "`""

    }

    <#
        function _codepointToLiteral {
            param(
                [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
                $Rune
                # [Rune]$Rune
            )
            process {
                Join-String {
                    $Template.SingleRune -f $Rune
                } -sep '' -op "`"" -os "`""
            }
        }
    }
    process {
        $InputText.EnumerateRunes() | ForEach-Object {
            $cur = $_
            if ($cur.IsAscii) {
                $_; return
            }
            _codepointToLiteral $_
        }

        # previous
        <#
        $InputText.EnumerateRunes() | Join-String {
            if ($PreserveAscii -and $_.Value -le 127) {
                $_ ; return
            }

            $Template.SingleRune -f $_.Value
        } -sep '' -op "`"" -os "`""

    }
    #>
    end {}
}

if ($DebugInlineToggle) {
    'a f23jaf23j' | ConvertTo-PwshLiteral -PreserveAscii
    | Join-String -op '-PreserveAscii: '
    'a f23jaf23j' | ConvertTo-PwshLiteral
    | Join-String -op 'default: '
}

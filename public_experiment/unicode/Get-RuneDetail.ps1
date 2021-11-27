Using namespace system.text
# using namespace globalization

$experimentToExport.function += @(
    'Get-RuneDetail'
)
$experimentToExport.alias += @(
    'Uni->RuneInfo'
)



function Get-RuneDetail {
    <#
    .synopsis
        test parts of a rune
    .description
        Desc
    .notes
        docs:
            - [struct Rune](https://docs.microsoft.com/en-us/dotnet/api/System.Text.Rune?view=net-5.0)
            - [Character encoding in .NET](https://docs.microsoft.com/en-us/dotnet/standard/base-types/character-encoding-introduction)
            - [grapheme \[StringInfo class\]](https://docs.microsoft.com/en-us/dotnet/api/system.globalization.stringinfo?view=net-5.0)

    .example
        `tHi`tworld`vthere`nend." | Get-RuneDetail
    .example
        🐒> Get-RuneDetail -InputText 'afz🐒>' | ft -AutoSize

    #>
    [Alias(
        'Uni->RuneInfo'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Docstring
        # Input Text/string
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [string]$InputText

    )

    begin {

        $str = @{
            Null       = '[null]'
            NullSymbol = "`u{2400}"
            # Nyi        = 'Nyi?'
        }
        $Simplify = $true
    }
    process {
        $InputText.EnumerateRunes()
        | ForEach-Object {
            $rune = $_
            $meta = [ordered]@{
                PSTypeName  = 'nin.RuneDetail'
                CodeHex     = '0x{0:x}' -f $Rune.Value
                # Name        = $Str.Nyi
                # Rune        = $Rune # Actual
                # RuneStr     = $Rune | CtrlChar # Safe value
                UniCategory = [Rune]::GetUnicodeCategory( $Rune )
            }
            if ($meta.UniCategory -notmatch 'control' ) {
                $meta['RuneOnRenderTest'] = "Good: '$Rune'"
            } else {
                $meta['RuneOnRenderTest'] = "Bad:  '$($meta['RuneStr'])'"
            }

            if (!$Simplify) {
                $meta += @{
                    # PwshLiteral = $Rune | ConvertTo-PwshLiteral
                    CodePoint       = $Rune.Value
                    GI_Category     = [Globalization.CharUnicodeInfo]::GetUnicodeCategory( $_.Value )
                    GI_DecimalDigit = [Globalization.CharUnicodeInfo]::GetDecimalDigitValue( $_.Value )
                    GI_DigitValue   = [Globalization.CharUnicodeInfo]::GetDigitValue( $_.Value )
                    GI_NumericValue = [Globalization.CharUnicodeInfo]::GetNumericValue( $_.Value )

                }

            }
            [PSCustomObject]$meta
        }
    }
    end {
        Write-Warning 'needs custom view format, use default properties, so I can include properties I do not want to print by default'
    }
}

if ($false) {
    $res = "`tHi`tworld`vthere`nend." | Get-RuneDetail
    $res
    | Format-List

    H1 'formatter should remove escape char cols'
    $res
    | Format-Table -AutoSize

    H1 'last: explicit test'
    $res | Select-Object RuneStr, CodeHex, RuneOnRenderTest, Name, UniCategory | Format-Table -AutoSize

}

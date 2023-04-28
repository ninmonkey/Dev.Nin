#Requires -Version 7
Using namespace system.text;
using namespace globalization;

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-RuneDetail'

    )
    $experimentToExport.alias += @(
        'Uni->RuneInfo' # 'Get-RuneDetail'

    )
}

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
        # added, to prevent errors on blank or null
        [AllowNull()]
        [AllowEmptyCollection()]
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
        # re-run-through before moving to nin
    }
    process {
        # todo: bug: errors when null, not getting caught # or system was cached
        if ( [string]::IsNullOrEmpty( $INputText) ) {
            Write-Debug '[RuneInfo]: leaving early (good)'
            return
        }
        if ($null -eq $InputText) {
            Write-Error -ea continue "[RuneInfo] ShouldNeverReach: NullValueException '$PSCommandPath'"
            return
        }
        Write-Debug '[RuneInfo]: continue'



        $InputText.EnumerateRunes()
        | ForEach-Object {
            $rune = $_
            $meta = [ordered]@{
                PSTypeName  = 'nin.RuneDetail'
                CodeHex     = '0x{0:x}' -f $Rune.Value
                UTF8Length  = $Rune.Utf8SequenceLength
                UTF16Length = $Rune.Utf16SequenceLength
                # Name        = $Str.Nyi
                # Rune        = $Rune # Actual
                # RuneStr     = $Rune | CtrlChar # Safe value
                UniCategory = [Rune]::GetUnicodeCategory( $Rune )
            }
            if ($meta.UniCategory -notmatch 'control' ) {
                $meta['Render'] = "'$Rune'"
            } else {
                $meta['Render'] = [rune]::new( $rune.value + 0x2400 ) | Join-String -SingleQuote
            }
            <#
            [Globalization.CharUnicodeInfo]::GetUnicodeCategory('a')
            #>
            # Write-Warning 'calling method was causing REPL error on crash'
            # Wait-Debugger

            if (!$Simplify) {
                $meta += @{
                    # PwshLiteral = $Rune | ConvertTo-PwshLiteral
                    CodePoint       = $Rune.Value
                    GI_Category     = [Globalization.CharUnicodeInfo]::GetUnicodeCategory( $_.Value )
                    GI_DecimalDigit = [Globalization.CharUnicodeInfo]::GetDecimalDigitValue( $_.Value )
                    GI_DigitValue   = [Globalization.CharUnicodeInfo]::GetDigitValue( $_.Value )
                    # GI_NumericValue = [Globalization.CharUnicodeInfo]::GetNumericValue( $_.Value )

                }

            }
            [PSCustomObject]$meta
        }
    }
    end {

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


if (! $experimentToExport) {
    # ...
}

if ($false) {
    $BaseDir = 'C:\Users\cppmo_000\Documents\2020\ninmonkeys.com ┐ main\Power BI\adding dates and numbers then to text\import from raw text - refactor\' | Get-Item -ea Stop
    $Paths = @{
        DataMashup = Join-Path $BaseDir -ChildPath 'DataMashup' | Get-Item -ea Stop
    }

    $codepoint = @{
        ReplacementChar = 0xfffd
    }

    $content = Get-Content $paths.DataMashup -Encoding utf8
    $regex = @{}
    # https://en.wikipedia.org/wiki/C0_and_C1_control_codes#C0_controls0x0x
    $regex.ControlCharC0 = '[\x00-\x1f]' # 0..31    | len: 31
    $regex.ControlCharC1 = '[\x80-\x9f]' # 128..159 | len: 31
    $regex.ControlCharSymbol = '[\x2400-\x2426]' #  | len: 38
    # $regex.ReplacementChar = '\xff\xfd'
    $regex.AllControlChars = '(?x)
    # [0-32)
    [\x00-\x20]
    |
    # delete 127
    \x7f
    |
    [\x1f-\x7f]
    |
    # 129-159
    [\x80-\x9f]
'
    $text

    function Format-ControlCharSymbol {
        <#
    .synopsis
        Replaces C0-control codes their unicode-symbol characters
    #>
        param(
            [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Text to map')]
            [Object]$Text
        )
        process {
            $Text.EnumerateRunes() | ForEach-Object {

            }

            $result = $result -replace $regex.ReplacementChar, $nin_uni.Named.NoSign
            $result = $Text -replace $regex.ControlCharC0, $nin_uni.Named.monkey
            $result
        }
    }
    function UnicodeStats {
        <#
    .synopsis
        count codepoint frequency
    #>
        param(
            [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Text to count')]
            [string[]]$Text
        )
        begin {
            [hashtable]$CodepointCount = @{}
        }
        process {

            $Text.EnumerateRunes() | ForEach-Object {
                $Rune = $_
                $CodepointCount[ $Rune.Value ] = 1 + ($CodepointCount[ $Rune.Value ] ?? 0 )
            }

            # $result = $result -replace $regex.ReplacementChar, $nin_uni.Named.NoSign
            # $result = $Text -replace $regex.ControlCharC0, $nin_uni.Named.monkey
            # $result
        }
        end {
            hr
            $CodepointCount.Keys | ForEach-Object {
                $Codepoint = $_
                $UsageCount = $CodepointCount.$Codepoint

                [pscustomobject]@{
                    Codepoint = $Codepoint
                    Hex       = '{0,4:x}' -f $Codepoint
                    # Hex       = $Codepoint.ToString('x')
                    # Hex       = $Codepoint.ToString('x')
                    # PaddedHex = '0x', $_.ToString('x6') -join ''
                    # WierdPad  = '0x{0,4:x}' -f $_
                    Rune      = [char]::ConvertFromUtf32( $Codepoint )
                    Count     = $UsageCount
                    # Name = '...'

                }
            } | Sort-Object Count -Descending

        }

    }


    function Format-ControlCharSymbolRegex {
        <#
    .synopsis
        Replaces C0-control codes their unicode-symbol characters
    #>
        param(
            [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = 'Text to map')]
            [string]$Text
        )
        process {
            $result = $result -replace $regex.ReplacementChar, $nin_uni.Named.NoSign
            $result = $Text -replace $regex.ControlCharC0, $nin_uni.Named.monkey
            $result
        }

    }


    function MapControlCharsManual {
        <#
    .synopsis
        make control chars human readable
        https://en.wikipedia.org/wiki/Control_character
    #>
        param($Content)
        $text = $Content -replace '\x00', $nin_uni.ControlCharsSymbols.Null

    }
    function CountNull {
        $content | ForEach-Object { $i = 0 } {
            if ( $_ -match '\x00' ) {
                $i++
            }
        }
        $i
    }


    function debugTests {
    ($content -match $regexAllControlChars).EnumerateRunes()
        | Sort-Object Value -Unique
        | ForEach-Object {
            $_.Value.ToString('x')
        }

    ($content -match $regexAllControlChars).EnumerateRunes()
        | Group-Object Value -AsHashTable -AsString | Sort-Object Count -Descending

        $runes = ($content -match $regexAllControlChars).EnumerateRunes()
        $runes | Group-Object Value | Sort-Object Count -Descending

    }

    # debugTests
    # $content | Format-ControlCharSymbol
    $stats = $content | UnicodeStats
    $stats | Format-Table Count, Hex, Rune

}
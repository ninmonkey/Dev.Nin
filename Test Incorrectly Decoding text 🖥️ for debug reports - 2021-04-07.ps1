using namespace system.collections.generic

if ($false) {
    # manually encoding one time
    $SampleText = [char]::ConvertFromUtf32( 0x1F601 )
    $bstr_uni = [Text.Encoding]::Unicode.GetBytes( $SampleText )
    $bstr_uni | hex | Join-String -sep ' ' | Label 'utf16-le'
}

function testDecode {
    param(
        # Encoding Name, ex: 'utf-8', 'utf8-16le'
        [Parameter(Mandatory, Position = 0)]
        [string]$EncodingName,

        # Text ex: '😁'
        [Parameter(Mandatory, Position = 1)]
        [Alias('Bytes')]
        [byte[]]$InputBytes
    )

    try {
        $decoder = [System.Text.Encoding]::GetEncoding($EncodingName)
    }
    catch {
        Write-Warning "Failed to get decoder: '$EncodingName'"
        throw $_
    }
    $text = $decoder.GetString($InputBytes)
    $text
}
function testEncode {
    <#
    .example
        🐒> testEncode -EncodingName 'utf-8' -InputString $monkey
        | _Format-Byte | Join-String -sep ' '

        f0 9f 90 92

        🐒> testEncode -EncodingName 'utf-16le' -InputString $monkey
        | _Format-Byte | Join-String -sep ' '

        3d d8 12 dc

        🐒> testEncode -EncodingName 'utf-16be' -InputString $monkey
        | _Format-Byte | Join-String -sep ' '

        d8 3d dc 12

    #>
    param(
        # Encoding Name, ex: 'utf-8', 'utf8-16le'
        [Parameter(Mandatory, Position = 0)]
        [string]$EncodingName,

        # Text ex: '😁'
        [Parameter(Mandatory, Position = 1)]
        [Alias('Text')]
        [string]$InputString
    )

    try {
        $encoder = [System.Text.Encoding]::GetEncoding($EncodingName)
    }
    catch {
        "Failed to get encoder: '$EncodingName'"
        Write-Warning "Failed to get encoder: '$EncodingName'"
        throw $_
    }

    $byteStr = $encoder.GetBytes($InputString)
    $byteStr
}

function _Format-Codepoint {
    param(
        # text
        [Parameter(mandatory, ValueFromPipeline)]
        [string]$InputText,

        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('UNotation')] #, 'BytesList')]
        [string]$Format


    )
    process {
        switch ($Format) {
            'UNotation' {
                $InputText.EnumerateRunes()
                | Join-String -FormatString 'U+{0:x}' Value -sep ', '
                | Label 'Codepoints'
                break
            }
            default { "Unhandled: '$Format'" }
        }
    }
}

function _Format-Byte {
    param(
        # bytes as list
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [byte[]]$InputBytes,

        # output everything as one string
        [Parameter()]
        [switch]$OneLine

        # # explicit separator
        # [Parameter()]
        # [string]$Separator
    )
    # begin {
    # #     $allBytes = get-
    # # }
    # process {
    #     if (! ($OneLine) ) {
    #         $InputBytes | Join-String -sep ' ' -FormatString '{0:x2}'
    #         return
    #     }
    process {
        $InputBytes | Join-String -sep ' ' -FormatString '{0:x2}'
    }

    # }
    # end {
    #     $InputBytes | Join-String -sep ' ' -FormatString '{0:x2}'
    # }

}

function _testMain {
    <#
    .synopsis
        invoke tests
    .example
        _testMain -SampleText 'zsfds' -Encoding 'utf-8', 'utf-16le'
        _testMain -SampleText 'zsfds'
    #>
    param(
        # text
        [Parameter(Mandatory, Position = 0)]
        [string]$SampleText,

        # text
        [Parameter(Position = 1)]
        [string[]]$Encoding
    )

    # $encodingsToTest = $Encoding ?? 'utf-8', 'utf-16le', 'utf-16be'
    # $encodingsToTest = $encodingsToTest | Sort-Object -Unique
    # $encodingsToTest = 'utf-8', 'utf-16le', 'utf-16be'
    $conditions = @(
        $Encoding.Length -eq 0
        $null -eq $Encoding
        [string]::IsNullOrWhiteSpace( $Encoding )
    )

    if ( ($conditions -eq $true).count -gt 0 ) {
        $encodingsToTest = 'utf-8', 'utf-16le', 'utf-16be' | Sort-Object -Unique
    }
    else {
        $encodingsToTest = $Encoding
    }



    h1 "Input String: '$SampleText'"



    $SampleText.EnumerateRunes() | Join-String -FormatString 'U+{0:x}' Value -sep ', ' | Label 'Codepoints'
    $encodingsToTest | Join-String -sep ', ' | Label 'Encodings'


    $encodingsToTest | ForEach-Object {
        $encName = $_
        h1 "encode: $encName"
        testEncode $encName $SampleText -ov 'lastEncode'
        | Join-String -Separator ' ' -FormatString '{0:x}'
        | Label $encName

        # $sample.EnumerateRunes() | Join-String -FormatString 'U+{0:x}' Value -sep ', ' | Label 'Codepoints'
        h1 'inner test' -fg purple
        # $lastEncode | _Format-Codepoint

        $encodingsToTest | ForEach-Object {
            $decName = $_
            testDecode -enc $decName -InputBytes $lastEncode -ov 'lastDecode'
            | Join-String -Separator '' -DoubleQuote
            | Label $decName

            _Format-Byte $lastEncode
            | Label 'bytes'

            # $lastDecode | Join-String -Separator ' ' -FormatString '{0:x}' -op 'part2 '
            $lastDecode
            | ForEach-Object enumerateRunes
            | Join-String -Separator ', ' {
                $_.Value | Join-String -FormatString 'U+{0:x}' # or 'U+{0:x8}'
            }
            | Label "$decName codepoints"

            $lastDecode
            | ForEach-Object enumerateRunes
            | Join-String -prop 'Value' -Separator ' ' -FormatString '{0:x}' -os "`n"
            | Label $decName

            _Format-Byte $lastEncode
            | Label 'bytes'
        }

    }

}

$family = '👨‍👦‍👦'
$familyManBoy = '👨‍👦'
$SampleList = @(
    $emoji
    $monkey
    $emoji, $monkey -join '+'
    $family
)
$mainEncodingList = 'utf-8', 'utf-16le', 'utf-16be'

if ($false -and 'config: short test') {
    $mainEncodingList = $mainEncodingList | Select-Object -First 1
    $SampleList = $SampleList | Select-Object -First 1
    $SampleList = @($emoji, $monkey -join '-')
}
if ($true) {
    $SampleList = @($monkey, ' hi' -join '')
}

$SampleList = @('🐒')
if ($false) {
    # single run
    $what = ($SampleList -join '')
    $what = '🐒'
    _testMain -SampleText $what -Encoding 'utf-16le'
}
else {
    $SampleList | ForEach-Object {
        h1 '__main' -fg 'orange' -bef 0 -af 0
        _testMain -SampleText $_ -Encoding $mainEncodingList
    }
}

& {
    h1 'test runner'
    $bStr = [byte[]]@(0xf0, 0x9f, 0x90, 0x92)
    testDecode -EncodingName 'utf-8' -InputBytes $lastBstr | Should -Be '🐒'
    hr

    testDecode -EncodingName 'utf-8' -InputBytes $lastBstr
    | Should -Be '🐒'

    $bStr = [byte[]]@(0xf0, 0x9f, 0x90, 0x92) # utf8 encoded monkey as bytes
    testEncode -EncodingName 'utf-8' -InputString '🐒' | Should -Be $bStr
}
Write-Warning 'This mixes encoding and decoding as an example to show incorrect usage,
meaning this should not be a utility'

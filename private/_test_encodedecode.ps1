function testDecode {
    <#
    .synopsis
        wrapper to quickly test encode/decode
    .example
        testDecode -EncodingName 'utf-8' -InputBytes (testEncode '🐒' -EncodingName 'utf-8') | Should -Be '🐒'
    .link
        testEncode
    #>
    param(
        # Encoding Name, ex: 'utf-8', 'utf8-16le'
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter( {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                'utf-8', 'utf-16le', 'utf-16be', 437
            })]
        [string]$EncodingName,

        # Text ex: '😁'
        [Parameter(Mandatory, Position = 1)]
        [Alias('Bytes')]
        [byte[]]$InputBytes
    )

    try {
        $decoder = [System.Text.Encoding]::GetEncoding($EncodingName)
    } catch {
        Write-Warning "Failed to get decoder: '$EncodingName'"
        throw $_
    }
    $text = $decoder.GetString($InputBytes)
    $text
}

function testEncode {
    <#
    .synopsis
        wrapper to quickly test encode/decode
    .example
        testDecode -EncodingName 'utf-8' -InputBytes (testEncode '🐒' -EncodingName 'utf-8') | Should -Be '🐒'
    .link
        testDecode
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
        [ArgumentCompleter( {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                'utf-8', 'utf-16le', 'utf-16be', 437
            })]
        [string]$EncodingName,

        # Text ex: '😁'
        [Parameter(Mandatory, Position = 1)]
        [Alias('Text')]
        [string]$InputString
    )

    try {
        $encoder = [System.Text.Encoding]::GetEncoding($EncodingName)
    } catch {
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
            default {
                "Unhandled: '$Format'"
            }
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


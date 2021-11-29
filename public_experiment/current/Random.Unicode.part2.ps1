if ($false) {

    function ConvertHexTo-Bytes {
        <#
    .notes
        if length is not even, first element grabs one char only
        one char does work on [unit]::parse]
    .example
        PS> ConvertHexTo-Bytes -HexString 'abcd'
        171, 205
    .example
        PS> ConvertHexTo-Bytes -HexString 'abcde'
        10, 188, 222
    #>
        param(
            [Parameter(Mandatory, Position = 0, HelpMessage = 'Hex string as text to convert to binary, length can be odd')]
            [string]$HexString
        )

        if ($HexString.Length % 2 -ne 0) {
            $HexString = '0' + $HexString
        }
        $HexString | Write-Debug

        $bytes = for ($i = 0; $i -lt $HexString.length; $i += 2) {
            $pair = $HexString.Substring($i, 2)
            [uint]::Parse($pair, [System.Globalization.NumberStyles]::AllowHexSpecifier)
        }
        $bytes
    }

    # &{ if($run_tests) {
    & { if ($false) {

            $bytes = (Get-ChildItem . -File)[0] | Get-Content -AsByteStream | Format-Hex -Count 16 | Select-Object -ExpandProperty Bytes
            $bytes | Join-String -sep ' ' -FormatString '{0:x2}'
            hr
            $bytes | Format-Hex
            if ($false) {
                $DebugPreference = 'Continue'
                ConvertHexTo-Bytes -HexString 'abcd'
                ConvertHexTo-Bytes -HexString 'abcde'
                ConvertHexTo-Bytes -HexString 'f'
                ConvertHexTo-Bytes -HexString '0f'
                ConvertHexTo-Bytes -HexString 'ff'
                ConvertHexTo-Bytes -HexString 'fff'
                ConvertHexTo-Bytes -HexString '0fff'
                ConvertHexTo-Bytes -HexString 'ffff'
            }

        } }

    <# from console:

    ls $env:USERPROFILE -Recurse *.code-workspace -depth 4
        | sort LastAccessTime -Descending -ov ls_all
        | select -First 20 -ov ls_recent

    $calcProp = @{
        Name = 'parent[s]'
        Expression = {  $_.Directory.Name }
    }

    $ls_recent | ft Name, $calcProp, Definition  -GroupBy MemberType

    #>
    # Label 'Todo:' 'Auto save most recent files to a list'


    Function Get-CodePage {
        'this should be a base class?'
        [System.Text.UTF8Encoding]::GetEncoding(437)
        Write-Error 'nyi: shortcut to get encoding info by name (not config of stdin/out)'
        # BodyName          : utf-8
        # EncodingName      : Unicode (UTF-8)
        # CodePage          : 65001
    }


    function Format-Bytes {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
            [byte[]]$ByteString,

            [Parameter(Mandatory = $false, Position = 1, HelpMessage = 'same as Format-Hex -Count')]
            [long]$Count = [long]::MaxValue,

            [Parameter(Mandatory = $false, Position = 2, HelpMessage = 'same as Format-Hex -Offset')]
            [long]$Offset = 0,

            [Parameter(Mandatory = $false, HelpMessage = 'Change output modes')]
            [ValidateSet('None', 'Hex', 'Dec', 'Runes')]
            [string]$FormatMode = 'Hex',

            [Parameter(Mandatory = $false, HelpMessage = 'string used to pad values')]
            [string]$Separator = ' '

        )
        $FormatMode | Write-Debug
        $SelectedBytes = $ByteString | Format-Hex -Count $Count -Offset $Offset
        | Select-Object -ExpandProperty Bytes

        switch ($FormatMode) {
            'Runes' {
                Write-Warning 'Runes: wip'
                $SelectedBytes
                | Join-String -Separator $Separator -FormatString '{0:d3}'
                break
            }
            'Dec' {
                $SelectedBytes
                | Join-String -Separator $Separator -FormatString '{0:d3}'
                break
            }
            'Hex' {
                # default for now
                $SelectedBytes
                | Join-String -Separator $Separator -FormatString '{0:x2}'
                break
            }
            # 'None' { }
            default {
                # none returns the actual bytestring
                $SelectedBytes
            }

        }
        # $bytes | Join-String -Separator $Separator -FormatString '{0:x2}'
    }

    # & { if ($run_tests) {
    & { if ($false) {
            h1 'Format-Bytes: test'
            $bytes = (Get-ChildItem . -File)[0] | Get-Content -AsByteStream
            $bytes | Format-Bytes
            hr
            Format-Bytes $bytes -Count 32 -Debug
            hr
            Format-Bytes $bytes -FormatMode None -Count 4 -Debug
            hr
            Format-Bytes $bytes -FormatMode Dec -Count 32 -Debug -Separator ','
            Format-Bytes $bytes -FormatMode Dec -Count 6 -Debug -Separator '  -  '
            hr
            Format-Bytes $bytes -FormatMode Runes -Count 32 -Debug
            h1 'done'

            # Get-BytesUnicode  -Text @('cat', 'dog')
            # Get-BytesUnicode -Encoding UTF8 -Text @('cat', 'dog')
            # Get-BytesUnicode -Encoding OEM -Text @('cat', 'dog')
            # Get-BytesUtf8 -Text @('cat', 'dog')
        } }

    Function Get-BytesUnicode {
        <#
    .description
        Pretty-print String as encoded bytes
    .exampleq
        > Get-BytesUtf8 "`u{1F412}"
        f0 9f 90 92

    .example
        > Get-BytesUtf8 $nin_uni.Named.monkey
        f0 9f 90 92

    .notes
        'Unicode' means .net 'unicode': utf-16-le
        - [ ] todo: autocompleter for encodings
        - [ ] either
            UTF8 # autocomplete positionset = 0

        - [ ] else if -Encoding then
            -Encoding utf8, unicode, unicode_be, <codepage>

    #>
        [CmdletBinding()]
        param (
            [Parameter(Mandatory, Position = 0, HelpMessage = 'Unicode string in memory, ie: is not encoded')]
            [string]$Text,

            [Parameter(Mandatory, Position = 1, HelpMessage = 'Encoding type')]
            [ValidateSet('UTF8', 'Unicode', 'OEM')]
            [string]$Encoding
            # [ArgumentToEncodingTransformationAttribute()]
            # [ArgumentEncodingCompletionsAttribute]
            # [ValidateNotNullOrEmpty

        )


    }
}
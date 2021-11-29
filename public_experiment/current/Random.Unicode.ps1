if ($false) {
    # ' dsfdsD'.enumerateRunes() | ForEach-Object {
    # tangent from: https://discordapp.com/channels/180528040881815552/447476117629304853/724680061029974068
    # 3762504530

    #     "{0,4} 0x{0:x}" -f $_.Value ; [char]::ConvertFromUtf32( $_.Value )


    # }

    <#

see also:
    - https://en.wikipedia.org/wiki/Endianness
    - https://emojipedia.org/emoji-zwj-sequence/
    - https://apps.timwhitlock.info/unicode/inspect


#>
    function h1($label) {
        #  poly
        "`n`n====== $label ===== `n`n"
    }


    Write-Host -ForegroundColor DarkMagenta @'
RFI
    - is this gaurenteed as ordered?
        else wrap `$Text.EnumerateRunes() | ForEach-Object` to force it ?

'@

    h1 'setup sample'

    $DebugPreference = 'Continue'
    $VerbosePreference = 'Continue'

    Write-Warning 'next:
    - [ ] see if I can manually print bytes to vscode terminal
        for the proper rendering
        - as utf16le
            3D D8 12 DC
        - as surrogatge pair
            D83D DC12

    - [ ] else using conversion
        - go from utf8 bytes
            F0 9F 90 92
        - string = [convert]::decodeutf8
            - print(string)
        - then
            - [convert]::encodeutf16le( string )
            print(encoded)


    - dsf
        [char]::ConvertFromUtf32(128018)


        Encoding u32LE = Encoding.GetEncoding( "utf-32" );


    https://apps.timwhitlock.info/unicode/inspect/hex/1f412

    ref:

    Decoder.GetChars()
        <https://docs.microsoft.com/en-us/dotnet/api/system.text.decoder.getchars?view=netcore-3.1>

    Encoding.GetString():
        <https://docs.microsoft.com/en-us/dotnet/api/system.text.encoding.getstring?view=netcore-3.1#System_Text_Encoding_GetString_System_Byte___>

    DecoderExceptionFallback
    DecoderFallbackException
    DecoderFallbackBuffer
    DecoderReplacementFallback
        https://docs.microsoft.com/en-us/dotnet/api/system.text.decoderexceptionfallback?view=netcore-3.1

    Encoding.GetChars():
            <https://docs.microsoft.com/en-us/dotnet/api/system.text.encoding.getchars?view=netcore-3.1>
        String myStr = "za\u0306\u01FD\u03B2";

        // Encode the string using the big-endian byte order.
        byte[] barrBE = new byte[u32BE.GetByteCount( myStr )];
        u32BE.GetBytes( myStr, 0, myStr.Length, barrBE, 0 );

        // Encode the string using the little-endian byte order.
        byte[] barrLE = new byte[u32LE.GetByteCount( myStr )];
        u32LE.GetBytes( myStr, 0, myStr.Length, barrLE, 0 );

        // Get the char counts, decode eight bytes starting at index 0,
        // and print out the counts and the resulting bytes.
        Console.Write( "BE array with BE encoding : " );
        PrintCountsAndChars( barrBE, 0, 8, u32BE );
        Console.Write( "LE array with LE encoding : " );
        PrintCountsAndChars( barrLE, 0, 8, u32LE );
'

    function generateUniMetadata {
        param(
            [Parameter(Mandatory, Position = 0, HelpMessage = 'codepoint as an integer literal')]
            [int]$codepoint
        )
        begin {
        }
        process {
            "Codepoint: $codepoint" | Write-Verbose

            $metadata = @{ # [ordered]@{
                codepoint             = $codepoint
                codepoint_hex         = '0x{0:x}' -f $codepoint
                name                  = 'nyi'
                UnicodeCategory       = 'nyi'
                encoded_utf8          = @(0xf0, 0x9f, 0x90, 0x92).foreach([byte])
                encoded_utf8_hexbytes = @(0xf0, 0x9f, 0x90, 0x92).foreach([byte]) | Format-Hex | Select-Object -ExpandProperty HexBytes
                # encoded_utf8_str #= (0xf0, 0x9f, 0x90, 0x92).ToString

            }
            "$([pscustomobject]$metadata)" | Write-Debug
            $($metadata) | Write-Debug
            [pscustomobject]$metadata | Sort-Object

        }
        end {
        }
        # 0x1f412
    }

    throw 'bad'

    generateUniMetadata 0x1f412 -Debug
    $Monkey = generateUniMetadata 0x1f412 -Debug
    #$Monkey.bytes_utf8_str = $monkey.bytes_utf8
    # $monkey.bytes_utf8 | foreach { '0x{0:x}' -f $_ } | Join-String -Separator ', '

    @(0xf0, 0x9f, 0x90, 0x92).foreach([byte]) | Format-Hex | Select-Object Bytes, HexBytes


    $DebugPreference = 'SilentlyContinue'
    $verbosePreference = 'SilentlyContinue'


    h1 'test command'

    Write-Warning 'tests are disabled'
    exit

    function UniInspect {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory, ValueFromPipeline)]
            [String]$Text,

            [Parameter()]
            [switch]$AsHash

        )

        begin {

        }

        process {
            h1 'input'
            $Text

            h1 'codepoints'
            $Text.EnumerateRunes() | ForEach-Object {
                $codepoint = $_.Value
                # [pscustomobject][ordered]@{
                $RuneInfo = [ordered]@{
                    Dec   = '{0,-4:d}' -f $codepoint
                    Hex   = '0x{0,-4:x}' -f $codepoint
                    Glyph = [char]::ConvertFromUtf32( $_.Value )
                }

                if ($AsHash) {
                    $RuneInfo
                } else {
                    [pscustomobject]$RuneInfo
                }
            }
        }
        end {
        }
    }

    function BytesInspect {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory, ValueFromPipeline)]
            # [bytes[]]$InputBytes,
            $InputObject,
            #does default enumerate chars?

            [Parameter()]
            [switch]$AsHash

        )

        begin {

        }

        process {
            Write-Warning 'bytesinspect nyi'
            continue
            h1 'input'
            $InputObject

            h1 'rfi: is this bytes[] or char[]?
        '

            # see:
            #     ('43534') | % { $_.GEttype() }
            #     ('43534').ToCharArray() | % { $_.GEttype() }
            # neefd get bytes or get chars ro waht4eveR?
            $InputObject | ForEach-Object {
                $cur_byte = $_
                $ByteInfo = '0x{0,-4:x}' -f $cur_byte
                $cur_byte.gettype()

                # if ($AsHash) {
                #     $ByteInfo
                # }
                # else {
                #     [pscustomobject]$ByteInfo
                # }
                $ByteInfo
            }
        }
        end {
        }
    }



    '--'
    ' dsfdsD' | UniInspect | Format-Table

    '--'
    'one🐒two' | UniInspect | Format-Table Glyph, Hex

    '--'

    # 'one🐒two' | BytesInspect

    # '--'
    # BytesInspect -InputObject 'one🐒two'



    if ($false) {
        #    test other formatting
        h1 'hash'
        ' dsfdsD' | UniInspect -AsHash | Format-Table
        ' dsfdsD' | UniInspect -AsHash | Format-List

        h1 'custom object'
        ' dsfdsD' | UniInspect | Format-Table
        ' dsfdsD' | UniInspect | Format-List
    }

}
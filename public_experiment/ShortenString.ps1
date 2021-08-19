$experimentToExport.function += @(
    'ShortenString'
)
$experimentToExport.alias += @(
    'AbbrStr'
)
function ShortenString {
    <#
    .synopsis
        shorten string .. only if needed. optionally keep ends
    .notes
        todo: Validate whether .substring() is utf8 safe
        Or maybe enumerate codepoints, even though that's slow
        or try the grapheme data type
    #>
    [Alias('AbbrStr')]
    param(
        # Input text
        [Parameter(Mandatory, Position = 0)]
        [string]$Text,

        # Max number of chars
        [Parameter(Position = 1)]
        [int]$MaxLength = 60
    )
    process {
        $actualLen = $Text.Length
        if ($actualLen -le $MaxLength) {
            $Text
            return
        }

        $MaxLengthInBounds = [math]::min( $MaxLength, $ActualLen - 1 )
        $Text.Substring(0, $MaxLengthInBounds )
    }
}

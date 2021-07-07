function New-RegexToggleSensitive {
    [alias('RegexSensitive')]
    <#
    .synopsis
        Temporarily enable case sensitivity, then remove it


        '(?-i)SMB(?i)'
    #>
    param (
        # Inner Regex
        [Parameter(Position = 0, ValueFromPipeline)]
        [string]$Pattern,

        # As a literal
        [Parameter()]
        [switch]$WithEscapeRegex
    )

    process {
        if ($WithEscapeRegex) {
            $Pattern = [regex]::Escape( $Pattern )
        }
        "(?-i)$Pattern(?i)"
    }
}

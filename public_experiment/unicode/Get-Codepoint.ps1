#Requires -Version 7.0.0

# $experimentToExport.function += @(
#     'Get-Codepoint'
# )
# $experimentToExport.alias += @(

# )
# $experimentFuncMetadata += @{
#     # metadataRecord
#     Command = 'Format-Endcap'
#     Tags    = 'TextProcessing📚', 'Style🎨' # todo: build, from function docstrings
# }

function Get-Codepoint {
    <#
    .synopsis
        get unicode rune info, mainly sugar
    .notes
    reference:

    🐒> ('sfzf'.GetEnumerator() ).GetType()
        returns
            [CharEnumerator] from:

    🐒> ('sfzf'.EnumerateRunes() ).GetType()

        returns
            [Text.StringRuneEnumerator] from:

    #>
    param(
        # Text array/list
        [Alias('Text')]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [string]$InputObject
    )

    # todo: final cleaning pass
    begin {}
    process {
        # if($InputObject.count -eq 1) {
        #     # when a single value, return without label
        $InputObject.EnumerateRunes() | % {
            $curRune = $_ # is type: [Text.Rune]

            $meta = [PSCustomObject]@{
                'PSTypeName' = 'Nin.Unicode.CodepointInfo'
                Codepoint    = $_.Value
                Rune         = $_ # or Glyph
                RuneInstance = [Text.Rune]::new( $_.Value )
                # future: Make .tostring() render as
                #   U+0x2400 [␀]
            }
            $meta
        }
    }
    end {}
}

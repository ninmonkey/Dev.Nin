
$experimentToExport.function += @(
    'New-Rune'
    # 'ConvertTo-Rune' # not sure which is more correct?
)
$experimentToExport.alias += @(
    'Get-NamedRune'
    'UniChar'
)
# }
    
    
function New-Rune {
    <#
        .synopsis
            New Rune using unicode name, or codepoint
        .description
            .
        .example            
        .outputs
            [Text.Rune]
        .link
            # Dev.Nin\_enumerateProperty
        .link
            Dev.Nin\iProp
        #>
    [Alias('Get-NamedRune', 'UniChar')]
    [cmdletbinding()]
    [OutputType('Text.Rune')]
    param(
        # any object
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [AllowNull()]            
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,
        # # preset column order, and to out-griview
        # [alias('oGv')]
        [parameter()]
        [switch]$FormatControlChar
    )
    process {
        $meta = @{}
        switch ($InputObject.GetType()) {
            { $_ -is 'String' } {
                write-warning 'unicode db lookup, fallback as url'
                'https://www.compart.com/en/unicode/search?q={0}#characters' -f @(
                    $InputObject
                )
                break
            }
            default {
                $result = [Text.Rune]::new( $InputObject )
                if($FormatControlChar) {
                    $result  | Format-ControlChar
                    break
                }
                $result
                break
            }
        }
    }
}
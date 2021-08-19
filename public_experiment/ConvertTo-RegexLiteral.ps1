$experimentToExport.function += 'ConvertTo-RegexLiteral'
$experimentToExport.alias += 'Re'

function ConvertTo-RegexLiteral {
    <#
    .synopsis
        sugar to quickly escape values to thier regex-literal
    .description

    .outputs

    #>
    [alias('Re', 'ReLit')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Text to convert to a literal
        [Alias('InputObject')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string[]]$Text
    )
    begin {}
    process {
        $Text | ForEach-Object {
            [regex]::Escape($_)
        }
    }
    end {}
}

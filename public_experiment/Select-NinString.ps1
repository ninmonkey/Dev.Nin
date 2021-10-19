$experimentToExport.function += @(
    'Select-NinString'
)
$experimentToExport.alias += @(
    'Hi', 'Hi🎨', 'Highlight'
)


function Select-NinString {
    <#
    .synopsis
        highlights patterns, listed as regex, color, regex, color
    .description
        uses pansies, but easily removed
    .notes
        - [ ] future: declare using pairs
    #>
    [Alias('Hi', 'Hi🎨', 'Highlight')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # pipeline console text
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$InputObject,

        #  basic filters
        [parameter(Mandatory, Position = 0)]
        # [validatescript({ $false })]
        [string]$Pattern,
        # [string[]]$Pairs

        #  basic filters
        [Alias('Fg')]
        [parameter(Position = 1)]
        [string]$Color = 'green'
    )
    begin {
        $ColorFg = [rgbcolor]$Color
    }
    process {
        $InputObject -replace $Pattern, {
            Write-Color $ColorFg -Text $_ | Join-String
        }
    }

}
function Select-NinStringSingleColor {
    <#
    .synopsis
        highlights patterns
    .description
        uses pansies, but easily removed
    .notes
        - [ ] future: declare using pairs
    #>

    [Alias('Highlight_Single')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # pipeline console text
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$InputObject,

        #  basic filters
        [parameter(Mandatory, Position = 0)]
        [string]$Pattern,

        #  basic filters
        [Alias('Fg')]
        [parameter(Position = 1)]
        [string]$Color = 'green'
    )
    begin {
        $ColorFg = [rgbcolor]$Color
    }
    process {
        $InputObject -replace $Pattern, {
            Write-Color $ColorFg -Text $_ | Join-String
        }
    }

}
function _formatColorNameTooltip {
    <#
    .synopsis
        generate colorized strings for the argument completer
    .description
        like this, but the qoutes is a colored block
        Goldenrod1' '
    .example
        🐒> _formatColorNameTooltip seagreen
        SeaGreen ' '

        🐒> _formatColorNameTooltip seagreen
        | Format-ControlChar -PreserveWhitespace

        SeaGreen '␛[97m␛[48;2;46;139;87m ␛[49m␛[39m'
    #>
    param(
        #  color name pair
        [Parameter(
            Mandatory, Position = 0,
            ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [object]$Color
    )
    process {
        if ($Color -is 'string') {
            $Color = [rgbcolor]$Color
        }
        @(
            $Color.X11ColorName
            ' '
            ' ' | write-color white -Bg $Color | Join-String -SingleQuote
        ) | Join-String
    }
}

# Get-ColorArgumentCompleter ?
function Get-ColorNameArgumentCompleter {
    <#
    .synopsis
        auto complete colors, previewd
    .description
       .
    .example
          .
    .outputs
          [string | None]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    begin {}
    process {
        'this will format tooltips in the completer like
        using: _formatColorNameTooltip

    but then the output/completion value could be the HEX string
    '




    }
    end {}
}
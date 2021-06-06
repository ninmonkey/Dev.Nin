using namespace PoshCode.Pansies

function _format_HslColorString {
    <#
    .synopsis
        formats [HslColor] to a [string], for use with Format.ps1xml
    .notes
        why? Better numeric summary, and aligned padding
    .example
        🐒> $hsl_color | _format_HslColorString

            # output is colored
            HSL(129, 87.9%, 48.4%) HSL(129, 87.9%, 48.4%)

    .example
        🐒> $hsl_color | _format_HslColorString -NoColor

            HSL(129, 87.9%, 48.4%)
    .example

    PS>
        $hsl_color = [rgbcolor]::FromRgb(15, 232, 49).ToHsl()

        $hsl_color |  _format_HslColorString

    # output
        HSL(129, 87.9%, 48.4%)
    .outputs
    [string]

    #>
    param(
        # Color object
        [Parameter(Mandatory, ValueFromPipeline)]
        [HslColor]$HslObject,

        # change format strings, for more compact or expressive formatting
        [Parameter(Position = 0)]
        [validateSet('Perfect', 'Compress')]
        [string]$AlignMode = 'Perfect', #'Compress'

        # Skip colorizing
        [Parameter()][switch]$NoColor

    )
    process {

        if (! $NoColor) {
            $text = _format_HslColorString -HslObject $HslObject -NoColor -AlignMode $AlignMode
            @(
                New-Text $text -fg $HslObject
                New-Text $text -bg $HslObject
            ) | Join-String -sep ' '
            return
        }


        switch ($AlignMode) {
            'Perfect' {
                $finalText = @(
                    # if no decimal, max width is 4,
                    # else 'p1' is 6
                    '{0,4}' -f $HslObject.H.tostring('n0')
                    '{0,6}' -f (
                        ($HslObject.S / 100).ToString('p1')
                    )
                    '{0,6}' -f (
                        ($HslObject.L / 100).ToString('p1')
                    )
                ) | Join-String -sep ', ' -op 'HSL(' -os ')'
                break
            }
            'Compress' {
                $finalText = @(
                    '{0}' -f $HslObject.H.tostring('n0')
                    '{0}' -f (
                        ($HslObject.S / 100).ToString('p0')
                    )
                    '{0}' -f (
                        ($HslObject.L / 100).ToString('p0')
                    )
                ) | Join-String -sep ',' -op 'HSL(' -os ')'
                break
            }
            default { throw "UnhandledAlignMode: $AlignMode" }
        }

        $finalText
    }

}

function _format_RgbColorString {
    <#
    .synopsis
        formats [RGBColor] to a [string], for use with Format.ps1xml
    .notes
        why? Better numeric summary, and aligned padding
    .example
        🐒> $RGB_color | _format_RGBColorString

            # output is colored
            RGB(129, 87.9%, 48.4%) RGB(129, 87.9%, 48.4%)

        🐒> $RGB_color | _format_RGBColorString -NoColor

            RGB(129, 87.9%, 48.4%)
    .example

    PS>
        $RGB_color = [rgbcolor]::FromRgb(15, 232, 49)
        $RGB_color |  _format_RGBColorString

        $RGB_color = [RgbColor]'gold'
        $rgb_color | _format_RgbColorString

    # output
        RGB(129, 87.9%, 48.4%)
    .outputs
    [string]

    #>
    param(
        # COlor
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [RGBColor]$RGBObject,

        # Skip colorizing
        [Parameter()][switch]$NoColor

    )

    process {
        write-error 'wip: debug me'
        if (! $NoColor) {
            $text = _format_RgbColorString -RGBObject $RGBObject -NoColor
            @(
                New-Text $text -fg $RGBObject
                New-Text $text -bg $RGBObject
            ) | Join-String -sep ' '
            return
        }

        $join_Rgb = @{
            Separator    = ', '
            FormatString = '{0,3:n0}'
            OutputPrefix = 'RGB('
            OutputSuffix = ')'
        }

        $FinalText = $rgb_color.Ordinals
        | Join-String @join_Rgb
        $finalText
    }

}

if($false) {
Hr
Get-ChildItem fg: | Get-Random | _format_RgbColorString -NoColor
}
using namespace PoshCode.Pansies

function Format-DevColor {
    <#
    .example
        PS> [RgbColor]'red' | Format-DevColor RenderTest
    .example

        Get-DevSavedColor -PassThru
            | % value | _format_HslColorString
    .notes
    todo: refactor or move to /colors module

    Casting **appears** to work, like parameter type [hslcolor]
        coerces into HSL from RGB Automatically
        $rgbColor | _format_HslColor

    related:
        [HSL colors]<https://en.wikipedia.org/wiki/HSL_and_HSV>

    ranges:
        Hue             = [0..360)
        Saturation      = [0..100] %
        Lightness/Value = [0..100] %
        hsl(240, 50%, 18%)
    #>
    param(
        # Docstring
        [Parameter(Mandatory, ValueFromPipeline)]
        [RgbColor]$InputObject,

        # FormatMode
        [Parameter(Position = 0)]
        [ValidateSet('RenderTest', 'VerboseRender')]
        [string]$FormatMode = 'RenderTest',

        # PassThru return object as is
        [Parameter()][switch]$PassThru
    )

    process {
        if ($PassThru) {
            $InputObject
            return
        }

        switch ($FormatMode) {


            'RenderTest' {
                @(
                    New-Text $Name -fg $InputObject | ForEach-Object tostring
                    New-Text $Name -bg $InputObject | ForEach-Object tostring
                ) -join ' '
                break
            }

            'VerboseRender' {
                $cur = $InputObject
                $curHsl = $cur.ToHsl()

                $str_Rgb = $cur | _format_RgbColorString
                $str_Hsl = $curHsl | _format_HslColorString

                @(
                    $cur.Mode
                    # $cur.ConsoleColor
                    $cur.X11ColorName
                    $str_Rgb
                    $str_Hsl

                ) -join "`n"
                break
            }


            default {
                throw "MissingFormatMode: $FormatMode"
            }
        }
    }
}

if ($false) {

    $aColor = Get-DevSavedColor -PassThru | Select-Object -First 1 | ForEach-Object Value

    $aColor | Format-DevColor 'RenderTest'
    $aColor | Format-DevColor 'VerboseRender'
    hr


}

function Format-DevColor {
    <#
    .example
        PS> $dev_colors.Red | Format-DevColor RenderTest
    #>
    param(
        # Docstring
        [Parameter(Mandatory, ValueFromPipeline)]
        [RgbColor]$InputObject,

        # FormatMode
        [Parameter(Position = 0)]
        [ValidateSet('RenderTest')]
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

            default { throw "MissingFormatMode: $FormatMode" }
        }
    }

}
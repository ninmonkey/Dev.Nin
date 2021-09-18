$experimentToExport.function += @(
    '_write-AnsiBlock'
    '_format-AnsiForFzf'
)
$experimentToExport.alias += @(
    # 'All' # breaks pester
    # 'Any'
)



function _write-AnsiBlock {
    <#
    .notes
        see: <https://github.com/PoshCode/Pansies/blob/master/Source/Pansies.format.ps1xml>
        see: <C:\Users\cppmo_000\Documents\2021\Powershell\buffer\2021-09\Colors>
    #>
    [alias('_format-AnsiBlock')]
    param(
        # Object is assumed to be RgbColor instance
        [Alias('Color')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # NoName
        [Alias('NoText')]
        [Parameter()][switch]$NoName
    )

    process {
        $color = [PoshCode.Pansies.RgbColor]$InputObject
        $blockRender = $color.ToVtEscapeSequence($true) + " ${bg:clear}"

        if ($NoName) {
            $blockRender
            return
        }
        $Name = if ($_ -is [PoshCode.Pansies.RgbColor]) {
            $_.Mode
        }
        else {
            $_.GetType().Name
        }

        $finalStr = $blockRender + " $Name"
        $finalStr
    }
}



function _format-AnsiForFzf {
    <#
    .synopsis
        'pretty print' color to pipe to fzf
    .notes
        see: <https://github.com/PoshCode/Pansies/blob/master/Source/Pansies.format.ps1xml>
    #>
    # [alias('_format-AnsiBlock')]
    param(
        # Object is assumed to be RgbColor instance
        [Alias('Color')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject
    )

    process {
        $cur = [rgbcolor]$InputObject
        $pad = '' # "`n"
        @(
            $prefix = @(
                $curColor | _write-AnsiBlock
                $curColor.X11ColorName
            ) | Join-String -sep ' '

            $prefix.padright(50)
            # $curCOlor_.RGB
            $curColor.Rgb
            # $curColor | _format_HslColorString
        ) | Join-String -op "$pad" -sep ' '
    }
}

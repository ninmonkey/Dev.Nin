$experimentToExport.function += @(
    '_format-AnsiForFzf'
    'Write-AnsiBlock'
    'New-VtEscapeClearSequence'
)
$experimentToExport.alias += @(
    '_write-AnsiBlock'
    # 'All' # breaks pester
    # 'Any'
)


function New-VtEscapeClearSequence {
    <#
    .synopsis
        generate reset ansi sequences
    .description
        -Fg or -Bg, if none are specified, it clears both
        written before $PSStyle.Reset
    .example
        PS> New-VtEscapeClearSequence -Background -Foreground | Format-ControlChar

            ␛[39m␛[49m
    .example
        PS> New-VtEscapeClearSequence -Foreground | Format-ControlChar

            ␛[39m
    #>
    param(
        # Clear/reset Foreground
        [Alias('Fg')]
        [Parameter()][switch]$Foreground,

        # Clear/reset Background
        [Alias('Bg')]
        [Parameter()][switch]$Background
    )

    if (! $Foreground -and ! $Background ) {
        $Foreground = $true
        $Background = $true
    }

    @(
        $Foreground ? "${fg:clear}" : $null
        $Background ? "${bg:clear}" : $null
    ) | Join-String
}

function New-VtEscapeSequence {
    [cmdletbinding()]
    param(
        # Color instance, or text instance
        [Alias('Fg')]
        [AllowNull()]
        [Parameter(Mandatory, Position = 0)]
        [rgbcolor]$ColorForeground,

        [Alias('Bg')]
        [AllowNull()]
        [Parameter(Mandatory, Position = 1)]
        [rgbcolor]$ColorBackground


    )
    # ToVtEscapeSequence
}

function Write-AnsiBlock {
    <#
    .synopsis
        draw a rectangle color, optionally with ModeType with colormode
    .notes
        $nulls are converted into "␀"

        see: <https://github.com/PoshCode/Pansies/blob/master/Source/Pansies.format.ps1xml>
        see: <C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\buffer\2021-09\Colors>
        see: <C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\buffer_prototypes\ANSI color\AnimatedAnsi-Powershell-random-letters-like-matrix.2022-01.ps1>
    .example
        PS>
        [rgbcolor]'green' | _write-AnsiBlock | Format-ControlChar

            ␛[102m ␛[49m ConsoleColor


    .example
        # draw a green block
        PS> _write-AnsiBlock green | Format-ControlChar
        ␛[102m ␛[49m
    .outputs
        text with Ansi escapes
    #>
    [alias('_format-AnsiBlock', '_write-AnsiBlock')]
    [OutputType([string])]
    param(
        # Object is assumed to be RgbColor instance
        [Alias('Color')]
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # NoName
        [Alias('NoText', 'WithoutMode')]
        [Parameter()][switch]$NoName
    )

    begin {
        $NullStr = "`u{2400}"

    }

    process {

        # draw null values as ␀

        if ($null -eq $InputObject) {
            "${bg:white}${fg:black}`u{2400}${fg:clear}${bg:clear}"
            return
        }

        $color = [PoshCode.Pansies.RgbColor]$InputObject
        $blockRender = $color.ToVtEscapeSequence($true) + " ${bg:clear}"

        if ($NoName) {
            $blockRender
            return
        }
        $Name = if ($InputObject -is [PoshCode.Pansies.RgbColor]) {
            $InputObject.Mode
        }
        elseif ($null -ne $InputObject) {
            $InputObject.GetType().Name
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

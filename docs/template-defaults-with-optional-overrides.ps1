function writeGradient {
    <#
        .synopsis
            Simple overridable defaults
        #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # ex: overriding existing color using key named 'color'
        [hashtable]$Color = Join-Hashtable -OtherHash ($Options.Color ?? @{}) -BaseHash @{
            Start = 'magenta'
            End   = 'Yellow'
            Fg    = 'black'
        }
        # defaults, that are overridable
        [hashtable]$Config = @{
            # Separator  = ', '
            Separator  = ''
            Format     = 'x'
            $rune      = '█'
            Iterations = 100
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
        $Color | Format-dict | wi
        $Config | format-dict | wi
    }
    process {
        # 0..($Config.Iterations) | ForEach-Object {
        #     $_.ToString($Config.Format)
        # } | Join-String -sep $Config.Separator

        # Get-Gradient -StartColor 'magenta' -EndColor 'yellow' -ColorSpace Lch -Height 1 -Flatten
        # | ForEach-Object { write-color -Text $rune -BackgroundColor $_ -fg $_ } | str str ''


        $rune = '='
        Get-Gradient -StartColor $Color.Start -EndColor $Color.End -ColorSpace Lch -Height 1 -Flatten
        | ForEach-Object { write-color -Text $Config.Rune -BackgroundColor $_ -fg $Color.Fg } | Join-String -Separator $Config.Separator

        # hr

        Get-Gradient -StartColor $Color.Start -EndColor $Color.End -ColorSpace Lch -Height 1 -Flatten
        | ForEach-Object { write-color -Text '=' -BackgroundColor $_ -fg black } | str str $Color.Separator

        # $rune = '█'
        # Get-Gradient -StartColor 'magenta' -EndColor 'yellow' -ColorSpace Lch -Height 1 -Flatten
        # | ForEach-Object { write-color -Text '=' -BackgroundColor $_ -fg black } | str str ''

        $InputObject
    }
    end {
    }
}

br 10
hr -fg magenta

(Get-Date) | writeGradient -options @{
    Rune = '█'
}

(Get-Date) | writeGradient -options @{
    Rune = ''
}
'bricks' | writeGradient -options @{
    Rune = '-'
}

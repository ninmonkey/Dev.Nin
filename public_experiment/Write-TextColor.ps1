#Requires -Module pansies
#Requires -Version 7.0.0
$experimentToExport.function += @(
    'Write-TextColor'
)
$experimentToExport.alias += @(
    'Write-Color'
    # 'Write-Text' ? write-color ?
    # 'All' # breaks pester
    # 'Any'
)

if ($false) {

    function Good {
        <#
    .synopsis
        example of a smart alias for Write-TextColor
    #>
        # print value as green -> good;  red -> 'bad'
        param(
            [Parameter(Mandatory, position = 0, ValueFromPipeline)]
            [ValidateNotNullOrEmpty()]
            [string]$Text
        )
        process {
            Write-TextColor -fg 'Green' -Text $Text
        }
    }
    function WriteHeader {
        # Header with padding
        param([string]$Text)
        $Text | Write-TextColor orange
        | Join-String -op "`n`n### " -os " ###`n"
    }
}
$__colorHistory ??= @()
function Dev.Get-ColorHistory {
    $__colorHistory
}
function Write-TextColor {
    <#
    .synopsis
        Writes Ansi Escape Sequence as string, instead of creating an color object
    .notes
        cleanup then merge into ninmonkey.console
    #>
    [Alias('Write-Color')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Foreground [rgbcolor]
        [Alias('Fg', 'Color')]
        [ValidateNotNullOrEmpty()]
        [Parameter(
            Mandatory, Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [PoshCode.Pansies.RgbColor]
        $ForegroundColor,

        # $Color = [rgbcolor]::new(164, 220, 255),
        # $ForegroundColor = [rgbcolor]::FromRGB((Get-Random -Max 0xFFFFFF)),

        # Background [RgbColor]
        [Alias('Bg')]
        [ValidateNotNullOrEmpty()]
        [Parameter(Position = 1)]
        # $Color = [rgbcolor]::new(164, 220, 255),
        [PoshCode.Pansies.RgbColor]
        $BackgroundColor, #= #[rgbcolor]::FromRGB((Get-Random -Max 0xFFFFFF)),

        [Alias('InputObject')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowEmptyString()]
        [ValidateNotNull()]
        # [ValidateNotNullOrEmpty()]
        [string]$Text,

        # When colors can be close
        [Parameter()]
        [switch]$LooseColorName
    )

    process {
        # if ($null -eq $Text) {
        #     $text ??= "`u{2400}"
        # }
        # Instead of crashing on close names, attempt to find something close
        # It uses the first match, so it may be weird. like 're' returns 'azure' instead of 're'
        if ($LooseColorName) {
            $ForegroundColor
            try {
                $closeColor = [rgbcolor]$ForegroundColor
            } catch {
                $closeColor = Find-color $ForegroundColor | Select-Object -First 1
            }
            $foregroundColor = $closeColor
            $BackgroundColor
            try {
                $closeColor = [rgbcolor]$BackgroundColor
            } catch {
                $closeColor = Find-color $BackgroundColor | Select-Object -First 1
            }
            $BackgroundColor = $closeColor
        }
        $__colorHistory += @(
            $ForegroundColor
            ($null -ne $BackgroundColor ? $BackgroundColor : $Null )
        )

        New-Text -Object $Text -fg $ForegroundColor -bg $BackgroundColor #-LeaveColor:$false
        | ForEach-Object ToString
    }
}

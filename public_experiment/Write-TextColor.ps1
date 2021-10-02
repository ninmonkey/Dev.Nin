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


function Write-TextColor {
    <#
    .synopsis
        Writes Ansi Escape Sequence as string, instead of creating an color object
    .notes
        cleanup then merge into ninmonkey.console
    #>
    [Alias('WriteTextColor', 'Write-Color')]
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

        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Text
    )

    process {
        New-Text -Object $Text -fg $ForegroundColor -bg $BackgroundColor | ForEach-Object ToString
    }
}

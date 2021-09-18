#Requires -Module pansies
#Requires -Version 7.0.0
$experimentToExport.function += @(
    'Write-TextColor'
)
$experimentToExport.alias += @(
    # 'All' # breaks pester
    # 'Any'
)



function Write-TextColor {
    [Alias('WriteTextColor')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        [Alias('Fg')]
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0)]
        # $Color = [rgbcolor]::new(164, 220, 255),
        $Color = [rgbcolor]::FromRGB((Get-Random -Max 0xFFFFFF)),

        [Parameter(Mandatory, Position = 1, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Text
    )

    process {
        New-Text -Object $Text -fg $Color | ForEach-Object ToString
    }
}

function Good {
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
    $Text | Write-TextColor orange | Join-String -op "`n`n### " -os " ###`n"
}

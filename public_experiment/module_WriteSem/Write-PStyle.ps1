#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # ''
        'Write-PStyleBold'
        'Write-PStyleClear'
        'Write-PStyleToggle'
    )
    $experimentToExport.alias += @(
        'PStyle->Bold' # 'Write-PStyleBold'
        'PStyle->Clear' # 'Write-PStyleClear'
        'PStyle->Mode' #  'Write-PStyleToggle'
    )
}

$script:__PStyle = @{
    # FgZero    = 'gray0'
    # FgDim4    = 'gray10'
    # FgDim3    = 'gray30'  # future, use relative functions
    # FgDim2    = 'gray40'
    # FgDim     = 'gray50'
    # FgDefault = 'gray60'
    # FgBright  = 'gray70'
    # FgBright2 = 'gray80'
    # FgBright3 = 'gray100'
}
$__PStyle += @{
    FgBold = $__PStyle.FgBright
}

enum PStyleMode {
    Reset
    BlinkOff
    Blink
    BoldOff
    Bold
    Hidden
    HiddenOff
    Reverse
    ReverseOff
    ItalicOff
    Italic
    UnderlineOff
    Underline
    StrikethroughOff
    Strikethrough
}
function Write-PStyleBold {
    [Alias('PStyle->Bold')]
    [CmdletBinding()]
    param(
        [switch]$Off
    )
    if ($Off) {
        $PSStyle.BoldOff
    } else {
        $PSStyle.Bold
    }
}

Function Write-PStyleToggle {
    <#
    .synopsis
        can output color, doesn't need text
        allow it for easier use
    .notes
        see:
            PS> $PSStyle | fm
    #>
    [Alias(
        'PStyle->Mode'
    )]
    param(
        [Alias('ClearAll')]
        [Parameter()]
        [switch]$ResetAll,

        [Parameter()]
        [PStyleMode[]]$Modes
    )

    if ($ResetAll) {
        return $PSStyle.Reset
    }

    foreach ($mode in $modes) {
        "Mode: $Mode"
    }

    # [switch]$Blink,
    # [switch]$Bold,
    # [switch]$Hidden,
    # [switch]$Reverse,
    # OutputRendering



}
Function Write-PStyleClear {
    <#
    .synopsis
        can output color, doesn't need text
        allow it for easier use
    .notes
        see:
            PS> $PSStyle | fm
    #>
    [Alias(
        'PStyle->Clear'
    )]
    param(
        [switch]$All
        # [switch]$Blink,
        # [switch]$Bold,
        # [switch]$Hidden,
        # [switch]$Reverse
    )

    if ($All) {
        return $PSStyle.Reset
    }
}
function Write-SemanticBold {
    <#
    .synopsis
        can output color, doesn't need text
        allow it for easier use
    .notes
        see:
            PS> $PSStyle | fm
    #>
    [Alias(
        'PStyle->Bold'
    )]
    param()
    begin {
        $state = $script:__PStyle
        Write-Error 'is redundant with PStyleToggle -Bold'
    }

}

function Write-SemanticPair {
    <#
    .synopsis
        semantics
    .notes
        see: PS> $PSStyle | fm
    #>
    [Alias(
        'Semantic->Bold',
        'Sem->Bold'
    )]
    param(
        [string]$Key,
        [string]$Value
    )

    Write-Color -fg 'gray60'
}


@(('len:' | write-color -fg 'gray60')
    30 | write-color -fg gray80  ) -join ''


if (! $experimentToExport) {
    # ...
}

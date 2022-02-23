#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # ''
    )
    $experimentToExport.alias += @(
        # ''
    )
}

$script:__colorSemantic = @{
    FgZero    = 'gray0'
    FgDim4    = 'gray10'
    FgDim3    = 'gray30'  # future, use relative functions
    FgDim2    = 'gray40'
    FgDim     = 'gray50'
    FgDefault = 'gray60'
    FgBright  = 'gray70'
    FgBright2 = 'gray80'
    FgBright3 = 'gray100'
}
$__colorSemantic += @{
    FgBold = $__colorSemantic.FgBright
}
function Write-PStyleBold {
    [Alias('Bold', 'PStyle->Bold')]
    [CmdletBinding()]
    param(
        [switch]$Off
    )
    $PSStyle.Bold
}

Function Write-SemanticClear {
    <#
    .synopsis
        can output color, doesn't need text
        allow it for easier use
    .notes
        see:
            PS> $PSStyle | fm
    #>
    [Alias(
        'Semantic->Clear',
        'Sem->Clear'
    )]
    param(
        [switch]$Fg,
        [switch]$Bg
    )
    $PSStyle.Reset
}
function Write-SemanticBold {
    <#
    .synopsis
        can output color, doesn't need text
        allow it for easier use
        the default is still color, not bold
    .notes
        see:
            PS> $PSStyle | fm
    #>
    [Alias(
        'Semantic->Bold',
        'Sem->Bold'
    )]
    param(
        [Parameter(Position = 0)]
        [ArgumentCompletions(2, 3)]
        [int]$Level,
        # use ansi-bold control char
        [switch]$UsingAnsi
    )
    begin {
        $state = $script:__colorSemantic
    }
    end {
        if ($UsingAnsi) {
            $PSStyle.Bold
        }

        $levelName = "Bright${Level}"
        if ($__colorSemantic.ContainsKey($LevelName)) {
            Write-Debug "Level: $LevelName"
            $state[ $levelName ]
        } else {
            Write-Debug 'Level: default'
            $state.ColorBright
        }
    }

}
function Write-SemanticDefault {
    [Alias('Semantic->Bold')]
    param()

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

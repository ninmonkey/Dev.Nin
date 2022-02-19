#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

    )
    $experimentToExport.alias += @(

    )
}
[hashtable]$script:__badStatusState = @{
    #6 unify saved/semantic colors
    #and/or grapheme

    #
    OtherRunes = @(
        '🔴🟥✅☑✔👆👍🙃⬆👇👎📩🔻'
        '🙊🙉🙈⛔🚫🚷good🟢🟩💚💔😍'
        '🩺👩‍⚕️👨‍⚕️🥼🩺💊💉'
        '🏃‍♂️🏃‍♀️'
        '✅☑✔'
        '🏴🚩'
        '😓😷😢😭😟😞😡😖😾😿💔😓☹😥😔😭😢😿😾😾😓☹😥😔😖😢😭😟😟😞'
        '😓😷😢😭😟😞😡😖😾😿💔😓☹😥😔😭😢😿😾😾😓☹😥😔😖😢😭😟😟😞'

    )

    $ColorMap  = @{
        Orange = @{
            Fg = 'orange'
            Bg = 'gray30'
        }
    }
    # semantic to colorname, then color name to rgb instance
    Mood       = @{
        'Warning' = 'Orange'
        'Bad'     = 'Bad'
        'BadIcon' = 2g
    }
}

class MoodStyle {
    # alias doesn't work ?
    [alias('ForegroundColor')]
    [rgbcolor]$Bg
    [rgbcolor]$Fg
}


$script:__badStatusState.Mood['Bad'] = [MoodStyle]@{
    'Fg' = 'Red'
    'Bg' = 'gray20'
}

function _getMoodColor {
    # map key to values
    param(
        # display all settings
        [alias('PassThru')]
        [Parameter()][switch]$List,
        [Parameter(Mandatory, position = 0)]
        [ValidateSet(
            'Bad', 'Good', 'Neutral', 'Warning', 'WarningIcon',
            'BadIcon', 'GoodIcon', 'NeutralIcon'
        )]
        [string]$Mood
    )

    $state = $script:__badStatusState
    $moodMap = $state.Mood
    # if(! $)
}
function Write-BadStatusMessage {
    <#
    #6 WIP
    #>
    param(
        [parameter(Mandatory, valuefromPipeline)]
        $InputObject,

        [parameter(Mandatory, position = 0)]
        [ValidateSet(
            'Bad', 'Good', 'Neutral', 'Warning', 'WarningIcon',
            'BadIcon', 'GoodIcon', 'NeutralIcon'
        )]
        [string]$Mood,

        [parameter(Mandatory, position = 1)]
        [string]$Message
    )
    begin {

    }
    process {
        Write-Color -fg orange -bg gray30
    }
}

if (! $experimentToExport) {
    # ...
}

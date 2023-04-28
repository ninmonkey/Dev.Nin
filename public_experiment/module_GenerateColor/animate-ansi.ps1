
function __lerp {
    <#
        normalize map values like for rgb

            0.5f => [int]127
    .synopsis
        used for example: animating 35 frames over 2 seconds

    interpolate make me
    #>

    param (
        $Value, $Min, $Max
    )
}
Write-Warning "Impl __lerp: $PSCommandPath"

function __enumerateAnimation {
    <#
    .synopsis
        get next frame in an animation
    .notes
        handles when next frame switches, to animate
    #>

    'NYI: also see: _enumerateColorGradient'
}

# __enumerateAnimation

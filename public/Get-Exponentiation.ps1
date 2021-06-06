
function Get-Exponentiation {
    <#
    .synopsis
        evaluate X to the power Y
    .description
        I couldn't think of a better name
        # https://en.wikipedia.org/wiki/Exponentiation
    .example
        PS> Pow 10 4
            10000
    .notes
        .
    #>
    [Alias('Pow')]
    param (
        # Base number
        [Parameter(Mandatory, Position = 0)]
        [double]$BaseNumber,

        # raise to power
        [Parameter(Mandatory, Position = 1)]
        [double]$Exponent
    )

    $Template = @{
        Exponent = "x`u{207f} = {0} ^ {1}"
    }
    Label ( $Template.Exponent -f ($BaseNumber, $Exponent) )
    | Write-Verbose

    [Math]::pow( $BaseNumber, $Exponent )
}

if ($test) {
    Pow 2 8
    Pow 2 8 -Verbose
}
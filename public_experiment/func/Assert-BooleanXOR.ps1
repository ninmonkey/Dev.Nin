$experimentToExport.function += @(
    'Assert-BooleanXOR'
)
$experimentToExport.alias += @(
)


function Assert-BooleanXOR {
    <#
    .synopsis 
        Compare two cases as bool-XOR
    .description
        The phrase I use to remember how an XOR works is:

            One or the other, but not both, and not none.

    truth table: <https://en.wikipedia.org/wiki/Exclusive_or> 

        0 0 = False
        0 1 = True
        1 0 = True
        1 1 = False

        # ex:
        foreach ($x in 0..1) { 
           foreach ($y in 0..1) { 
                $result = $x -xor $y
            "$x $y = $result"
            }
        }
    #>
    param(
        [ValidateNotNull()]
        [Parameter(Mandatory, Position = 0)]
        [bool]$Input1,
        
        [ValidateNotNull()]
        [Parameter(Mandatory, Position = 1)]
        [bool]$Input2
    )
    $Input1 -xor $Input2
}

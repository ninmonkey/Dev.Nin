function Compare-StrictEqual {
    <#
    .synopsis
        attempt -eq test, fail if types are not the same
    .notes
        this might be similar to:
            $A.Equals($B)

        todo: move to test module
    #>
    param(
        # First Object
        [Parameter(Mandatory, Position = 0)]
        [Alias('A')]
        [object]$ObjectA,

        # First Object
        [Parameter(Mandatory, Position = 1)]
        [Alias('B')]
        [object]$ObjectB
    )

    $ObjectA -eq $ObjectB -and $ObjectA -is $ObjectB.GetType()
}

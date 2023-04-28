#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Get-RandomInteger'
    )
    $experimentToExport.alias += @(
        'random->Int' # 'Get-RandomBoolean'
        'randInt' # 'Get-RandomBoolean'

    )
}

# needs to auto load directory
#

function Get-RandomInteger {
    <#
    .synopsis
        random ints
    .notes
        I was thinking call signature

            randInt Max
            randInt Min Max

        actual call func is exclusive
    .example
        # between 0 and 100
        PS> Random->Int

        # 0 to 20
        PS> Random->Int 20

        # 10 to 20
        PS> Random->Int 10 20

        # 3 numbers from the default range
        PS> Rawndom->Int -count 3
    #>
    [Alias('Random->Int', 'randInt')]
    [OutputType([System.Boolean])]
    [cmdletbinding()]
    param(
        #
        [Parameter(Position = 0)]
        [int]$Max = 100,

        [Parameter(Position = 1)]
        [int]$Min = 0,

        [Parameter(Position = 2)]
        [int]$Count = 1
    )

    $getRandomSplat = @{
        Minimum = $Min
        Maximum = $Max + 1
        Count   = 1
    }

    $getRandomSplat | Format-Table -AutoSize
    | Out-String | Write-Debug
    $getRandomSplat | Format-Table -AutoSize
    | Out-String | Write-Information

    Get-Random @getRandomSplat
    # 1 -eq (Microsoft.PowerShell.Utility\Get-Random -Minimum 1 -Maximum 3)
}

if (! $experimentToExport) {
    # ...
}

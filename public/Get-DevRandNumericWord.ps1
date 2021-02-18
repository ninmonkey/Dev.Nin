$numPerWord = 4
function Get-DevRandNumericWord {
    [alias('_randWord')]
    <#
    .example
    (0..10).ForEach({ _randWord -fixedNumDigits 2 })
    .example

        PS> # array/block of text
         0..4 | %{(0..10).ForEach({ _randWord -fixedNumDigits 2 })
            | Join-String -Separator ' ' -FormatString '{0,-4:n0}' }

        # output

            002  252  0    2    7    0    46   662  823  82   760
            2    346  0    812  444  840  65   72   47   6    7
            77   164  15   53   132  5    66   44   668  376  4
            8    152  1    80   770  274  05   7    61   047  8
            7    006  322  043  188  5    001  5    4    6    75


    #>

    # [CmdletBinding(DefaultParameterSetName = 'variableNumDigits')]
    [CmdletBinding(DefaultParameterSetName = 'fixedNumDigits')]
    param(
        # digits per word, '324' is '3'

        [Parameter(Mandatory, ParameterSetName = 'variableNumDigits', Position = 0)]
        [Parameter(Mandatory, ParameterSetName = 'fixedNumDigits', Position = 0)]
        [int]$minNumDigits = 1,

        [Parameter(Mandatory, ParameterSetName = 'variableNumDigits', Position = 1)]
        [int]$maxNumDigits = $numPerWord
        # [Parameter(Mandatory, ParameterSetName = 'fixedNumDigits', Position = 0)]

        # [int]$fixedNumDigits = $numPerWord


        # [Parameter(Position = 1)]
        # [int]$fixedNumDigits # or just set min and max?
    )

    switch ($PSCmdlet.ParameterSetName) {
        'variableNumDigits' {
            label 'vars'
            break
            $digit_count = Get-Random -Minimum $minNumDigits -Maximum $maxNumDigits
            Get-Random -Minimum 0 -Maximum 9 -Count $digit_count
            | Join-String -sep ''
            break
        }
        'fixedNumDigits' {
            label 'fixed'
            break
            Get-Random -Minimum 0 -Maximum 9 -Count $fixedNumDigits
            | Join-String -sep ''
            break
        }
        default { throw "ShouldNeverReach: $_" }
    }

}

function _randList {
    param(
        # number of
        [Parameter(Mandatory, Position = 0)]
        [int]$Count
    )

    0..($Count - 1) | ForEach-Object {

    }
}

if ($VerboseInlineTesting) {
    $numElements = 20
    $Samples = @{}
    $Sample['RandLength'] = 0..$numElements | ForEach-Object {
        _randWord 3 8
    }


    $Sample['FixedLength'] = 0..$numElements | ForEach-Object {
        # _randWord -fixedNumDigits 6
    }

    h1 'rand length 3..8'

    $Samples.RandLength

    h1 'fixed 6'

    $sample.FixedLength


    Write-Warning 'goto dev.nin?'
    break



    $count = Get-Random -Minimum 1 -Maximum $numPerWord
    Get-Random -Minimum 0 -Maximum 9 -Count $count | Join-String -sep ''
    <#

#>
    $sample = 0..40 | ForEach-Object { _randWord }

    h1 'naive'
    & {
        # all
        $sample | Join-String -sep ' ' -FormatString '{0,-4:n0}'
    }
    'grouped naive'
    br 2
    # & {
    # split
    & {
        $maxCols = [console]::WindowWidth
        # minus one to gaurentee some padding
        $numPerLine = [int]( $maxCols / $numPerWord ) - 1
        $numPerLine = [int]5

        $sample | Join-String -sep ' ' -FormatString '{0,-4:n0}'
        # }

        0..($numPerLine) | ForEach-Object {
            $segmentNum = $_
            # "Seg: $_"
            $listStart = $segmentNum * $numPerWord
            $listEnd = ($segmentNum + 1) * $numPerWord
            Label $listStart $listEnd | Write-Debug

            # $sample[$listStart..$listEnd]
            $sample[$listStart..($listEnd - 1)]
            | Join-String -sep ' ' -FormatString '{0,4:n0}'  # numPerWord

        }
    }
    # foreach ($i in 0..($sample.count - 1) ) {

    # "id: $i" | Write-Host -NoNewline
    # $numPerLine

    # } | Join-String -sep ''
    # $sample | ForEach-Object {
    #     0..$numPerLine | ForEach-Object {

    #     }
    # }
}
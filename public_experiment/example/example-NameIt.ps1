#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Example-NameIt'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

$script:__nameItExampleSB = @{
    Months = {
        $templates = $(
            'ThisQuarter'
            'q1', 'q3', 'q3', 'q4'
            'Today', 'Tomorrow', 'Yesterday'
            'February', 'April', 'October'
        )

        foreach ($template in $templates) {
            $template | ForEach-Object {
                [PSCustomObject]@{
                    Template = $_
                    Result   = Invoke-Generate "$_"
                }
            }
        }
    }
}



function Example-NameIt {
    <#
    .synopsis
        examples / cheatsheets for 'NameIt'
    #>
    param(
        # skip rendering
        [switch]$PassThru
    )
    # Requires -Module NameIt
    Import-Module NameIt

    $SingleLineExample = @'
ig '[color es]' -Count 3 -Culture (Get-Culture 'es-us')
ig '[color es]' -Count 3 -Culture (Get-Culture 'es')
ig '[noun]' -count 3
ig '[Person], [color en-GB]' -Count 3 -Culture (Get-Culture 'es')
ig '[Person], [Month en-GB]' -Count 3 -Culture (Get-Culture 'es')
ig '[Person], [Month]' -Count 3
ig '[randomdate]'
ig '[color][space][color en-GB]' -Culture ja-JP
ig '[randomdate]' # a random date in my culture format
ig "[randomdate '1/1/2000']" # a random date from 1 Jan 2000 onward
ig "[randomdate '1/1/2000' '12/31/2000']"  # a random date in the year 2000
ig "[randomdate '1/1/2000' '12/31/2000' 'dd MMM yyyy']"  # a random date in 2000 with a custom format

'@

    if ($PassThru) {
        Join-Hashtable $script:__nameItExampleSB -OtherHash @{SingleLine = $SingleLineExample }
        return
    }

    $script:__nameItExampleSB.GetEnumerator() | ForEach-Object {
        hr -fg magenta
        h1 $_.Key

        & $_.Value
    }

    # {
    #     $SingleLineExample | SplitStr -SplitStyle Newline
    #     | ForEach-Object -Begin { $count = 0; -proc } {
    #         # hr 2
    #         h1 "${count}"
    #         Invoke-Expression $_ # sorry
    #         $Count++
    #     }
    # }

    function _invokeCheatsheetExpression {
        # display formatted results as a reference
        # future: make rendered data it multi-column
        param(
            #Docstring
            [Parameter(Mandatory, Position = 0)]
            [string[]]$Expression,

            # Show code and results
            [Parameter()]
            [switch]$ShowCommand = $True
        )
        process {
            $Expression | SplitStr -SplitStyle Newline
            | ForEach-Object -Begin { $count = 0; } -proc {
                $cur = $_
                hr 2
                h1 "${count}"

                if ($ShowCommand) {
                    $cur
                    | BAT -l ps1
                }

                Invoke-Expression $cuR # sorry, forgive me.
                $Count++
            }
        }

    }

    _invokeCheatsheetExpression $SingleLineExample
}

# Example-NameIt


if (! $experimentToExport) {
    # ...
}

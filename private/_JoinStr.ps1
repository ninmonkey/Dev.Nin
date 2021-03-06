function JoinStr {
    <#
    .synopsis
        temp dev command to simplify pretty print
    .example
        PS> 3..102 | JoinStr

        PS> 0..2000 | Get-Random -Count 20  | JoinStr -width -8
        PS> 0..2000 | Get-Random -Count 20  | JoinStr -width 8
    #>
    [alias('Csv')] # will be smart alias
    param(
        # input list
        [Parameter(ValueFromPipeline, Mandatory)]
        [object[]]$InputObject,

        # format mode
        [Parameter(Position = 0)]
        [validateset('Default', 'Number', 'Experiment')]
        [string]$Mode = 'Default',

        # minimum text padding. positive numbers are right aligned.
        # (inverted formatstring for simplicity)
        [Parameter()]
        [Alias('Width')]
        [int]$CellWidth = 4,

        # spacing/separator
        [Parameter()]
        [string]$Separator = ' '
    )

    begin {
        $all_list = @()
        $colorSep1 = [RgbColor]'#5F6C85'
        $colorSep2 = [RgbColor]'#373E4C'  # '#7E90B1'
    }
    process {
        $all_list += $InputObject
    }
    end {
        $joinStrDefaults_splat = @{
            Separator    = $Separator #?? ' '
            FormatString = @( # '{0,-3}'
                '{0,'
                [string](1 * $CellWidth)  # allows non-neg padding?
                '}'
            ) -join ''
        }


        switch ($Mode) {
            'Experiment' {
                $defSep = $joinStrDefaults_splat['Separator']
                $formatStr = '{0,-3}'
                H1 '1'
                $colorSep = New-Text $defSep -bg $colorSep2  | ForEach-Object tostring
                $all_list | Join-String -sep $colorSep -FormatString $formatStr

                H1 2
                $all_list | Join-String -sep $defSep -FormatString $formatStr
                H1 3

                H1 4
                $all_list | Join-String -sep $colorSep {
                    $formatStr -f $_ | New-Text -bg $colorSep1
                }
                $all_list | Join-String -sep $defSep -FormatString $formatStr
                break
            }
            default {
                $joinStr_splat = $joinStrDefaults_splat
                $joinStr_splat | Format-HashTable | Write-Verbose
                $all_list | Join-String @joinStr_splat
            }

        }


    }
}
if ($false) {
    'a'..'z' + 'A'..'Z' + 0..9 | Get-Random -Count 30
    | JoinStr -Mode experiment -Verbose -ea break

    'a'..'f' | JoinStr -Verbose -ea break -Width 15
    'a'..'f' | JoinStr -Verbose -ea break -Width -15

    0..34 | JoinStr -Verbose -ea break


    h1 'sep ", "'
    43..31 | JoinStr -sep ', ' -Width 6
    43..31 | JoinStr -sep ', ' -Width -6

    H1 'sep " "'
    43..31 | JoinStr -sep ' ' -Width 6
    43..31 | JoinStr -sep ' ' -Width -6
}
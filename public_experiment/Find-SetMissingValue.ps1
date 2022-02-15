#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Find-SetMissingValue'
    )
    $experimentToExport.alias += @(
        'Compare->MissingSetList' # Find-SetMissingValue
    )
}

function Find-SetMissingValue {
    <#
        .synopsis
            For two arrays/sets, find values missing from both directions
        .notes
            todo: rewrite using actual set options
                [System.OrdinalComparer]

            current version is allowing coercion, so '3' == 3
            future version using <set> can set a custom compare conditions

        .example
            PS>
                Dev.Nin\Find-SetMissingValue -left @('a', '3', 'q', 'Q') -Right @('q', '6', 'a3')

                Right   Left
                -----   ----
                {6, a3} {a, 3}
        #>
    # [outputtype( [string[]] )]
    # [Alias('x')]
    [cmdletbinding()]
    [Alias(
        'Compare->MissingSetList'
    )]

    param(
        # docs
        [Alias('ListA', 'SetA')]
        [parameter(Mandatory, Position = 0)]
        [object[]]$Left,

        [Alias('ListB', 'SetB')]
        [parameter(Mandatory, Position = 1)]
        [object[]]$Right,


        # extra options
        [Parameter()][hashtable]$Options

        # using ? [System.OrdinalComparer]
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        # [hashtable]$Config = @{
        #     AlignKeyValuePairs = $true
        #     Title              = 'Default'
        #     DisplayTypeName    = $true
        # }
        $Config = Join-Hashtable $Config ($Options ?? @{})
        # $config = Join-Hashtable -OtherHash $Options -BaseHash @{}

    }
    process {

        # $Left = (lsFunc -Path .\func_map_dump.ps1 | ForEach-Object Name)


        # $Left = (lsFunc -Path .\func_map_dump.ps1 | ForEach-Object Name)


        $meta = @{
            PSTypeName = 'DevNin.FullOuterSetList'
        }
        $meta.Left = $Left | Where-Object {
            $Right -notcontains $_
        }
        $meta.Right = $Right | Where-Object {
            $Left -notcontains $_
        }

        [PSCustomObject]$meta

    }
    end {
    }
}


if (! $experimentToExport) {
    # ...
}

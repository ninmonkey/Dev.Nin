#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Sort-NameToEnd'
    )
    $experimentToExport.alias += @(
        # 'Sort->NameToEnd
    )
}

function Sort-NameToEnd {
    <#
    .synopsis
        from a list of names, push some to the end, without changing the rest
    #>
    [Alias(
        # -PushNameToEnd # ?
        # touch me, maake it a subutils module, not ninconsole
        # 'map->NamesToEnd', # ?
        # 'Sort->NameToEnd'
    )]
    [cmdletbinding()]
    param (
        #
        [Alias('Name')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$InputObject,

        # list of regex to shove to the end
        [Parameter(Mandatory, Position)]
        [string[]]$RegexPushName,

        # Use descending sort intead of ascending
        [Parameter()]
        [switch]$SortDescending
        # $PushRegex
    )
    begin {
        $names = [list[string]]::new()
        $mergedRegex = Join-Regex -Regex $RegexPushName
    }
    process {
        foreach ($name in $InputObject) {
            $names.Add( $name )
        }
    }
    end {
        $sortSplat = @{
            Descending = $SortDescending
            Property   = { $_ -match $mergedRegex }
        }

        $finalSort = $names | Sort-Object @sortSplat
        $finalSort
    }
}

if (! $experimentToExport) {
    # ...
}

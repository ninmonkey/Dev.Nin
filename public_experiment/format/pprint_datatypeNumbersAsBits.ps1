#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        pprint_datatypeAsBits
    )
    $experimentToExport.alias += @(
        # ''
    )
}


function pprint_datatypeAsBits {
    param( $TypeInfo )
    if (!($TypeInfo -is 'type')) {
        $type = $TypeInfo.GetType()
    } else {
        $type = $Typeinfo
    }
    $meta = [ordered]@{
        PSTypeName = 'devnin.TypeInfo.SummarizeBits'
        TInfo      = $type
        Name       = $type.name | Join-String -op '[' -os ']'
        Min        = $type::MinValue | bits #| Label min
        Max        = $type::MaxValue | bits #| Label max
    }
    [pscustomobject]$meta
}

if ($true) {


    if (! $experimentToExport) {
        [UInt16], [Int16], [Int64]
        | ForEach-Object {
            hr
            pprint_datatypeAsBits $_
            pprint_datatypeAsBits $_ | Format-List
        }

        h1 -fg magenta 'quickie save me'
        'plus colorize bits'
        # ...
    }
}

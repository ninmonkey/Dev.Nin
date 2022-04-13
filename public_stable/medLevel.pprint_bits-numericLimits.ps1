#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'pprint_datatypeAsBits'# ''
    )
    $experimentToExport.alias += @(
        # 'pp.List' # '' # ''
    )
}

Write-Warning '
nyi:
    - [ ] bits can pprint as | bits or
    - [ ] bits pprint as braile uni char
    - [ ] hex Print as nice pairs
'
# cleanup, same time as formatdata additions
function pprint_datatypeAsBits {
    param( $TypeInfo )
    if ($null -eq $TypeInfo) {
        return
    }
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


if ($False) {
    # if (! $experimentToExport) {
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

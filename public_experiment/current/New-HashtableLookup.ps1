#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-HashtableLookup'
    )
    $experimentToExport.alias += @(
        'Lookup'
    )
}

# New-PropertyPairFromObject
function New-HashtableLookup {
    <#
    .SYNOPSIS
        lookup and return (key,value) pairs from object/hashtable
    .description
        look up key->value pairs, return/create hash, or object,  optionally rename key
    .notes
        name? Dpair, Lookup, Prop, HashProp, pair? AttributePair, New

        call:
            $obj | Lookup Property
            <$obj> | Lookup <Property> [NewKeyName]
            Lookup <$obj> <Property> [NewKeyName]

        future:
        - [ ] allow object to be param
    .example
        PS> ls . -File | New-HashtableLookup 'Length'

    .example
        PS> ls . -File | New-HashtableLookup 'Length' 'Size'
    .example
        # dynamic calculated colPS> ls . -File | New-HashtableLookup 'Length' 'Size'
    .link
        Dev.Nin\New-HashtableFromObject
    .link
        Dev.Nin\New-HashtableLookup
    .link
        Dev.Nin\Assert-HashtableEqual
    .link
        Dev.Nin\Sort-Hashtable
    .outputs
          [hashtable] or [Collections.Specialized.OrderedDictionary]

    #>
    # linter complains about type 'ordered' not being returned
    # but [ordered] isn't a true data type in Pwsh, maybe a linter rule bug
    # [outputtype('Collections.Specialized.OrderedDictionary')]

    [alias('Lookup')]
    [cmdletbinding(DefaultParameterSetName = 'FromParam')]
    param(
        # input object or hashtable
        [Parameter( ParameterSetName = 'FromPipe', Mandatory, ValueFromPipeline)]
        [Parameter( ParameterSetName = 'FromParam', Mandatory, Position = 0)]
        [object]$InputObject,

        # literal property name
        [Alias('Property', 'Name')]
        [Parameter( ParameterSetName = 'FromPipe', Mandatory, Position = 0)]
        [Parameter( ParameterSetName = 'FromParam', Mandatory, Position = 1)]
        [string]$LiteralPropertyName,

        # optional key name
        # [Alias()]
        [Parameter( ParameterSetName = 'FromPipe', Position = 1)]
        [Parameter( ParameterSetName = 'FromParam', Position = 2)]
        [string]$NewKeyName
    )

    begin {
        '- [ ] finish by asking for group-object tips and hash key thingy
        - [ ] dynamically generated calculated props' | Write-Warning
    }
    process {
        $hash = @{}
        $FinalKeyName = $NewKeyName ?? $LiteralPropertyName

        $dbg = [ordered]@{
            NewKeyName          = $NewKeyName
            LiteralPropertyName = $LiteralPropertyName
            FinalKeyName        = $FinalKeyName
        }
        $dbg | Out-Default | Out-String | Write-Debug

        $newValue = $InputObject[ $LiteralPropertyName ]
        $dbg['NewProp1'] = $newValue
        $newValue ??= $InputObject.$LiteralPropertyName
        $dbg['NewProp2'] = $newValue
        $dbg['FinalKeyName'] = $FinalKeyName
        $dbg['LastValue'] = $newValue
        $dbg | Out-Default | Write-Debug
        # $dbg | dict | Out-String | Write-Debug

        $hash.add( $FinalKeyName, $newValue )
        return $hash
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
    $source1 = [pscustomobject]@{
        Species = 'Cat'
        Name    = 'Henry'
    }
    $source2 = Get-Date
    $Source3 = Get-Item .

    Get-Date | dict -LiteralInclude 'DayOfWeek'
}

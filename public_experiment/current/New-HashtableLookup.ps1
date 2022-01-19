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
        [string]$InputObject,

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
        $FinalKeyName = $NewKeyName ?? $LiteralPropertyName
        $newProp = $InputObject[ $LiteralPropertyName ]
        $newProp ??= $InputObject.$LiteralPropertyName
        $hash.add( $FinalKeyName, $newProp )
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
}

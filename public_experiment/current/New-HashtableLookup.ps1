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
        - [ ] finish by asking for group-object tips and hash key thingy


        - [ ] use for dynamically formatting calculated properties
    .example
        PS> ls . -File | New-HashtableLookup 'Length'
            Name Value
            ---- -----
            Size 158

    .example
        PS> ls . -file | Lookup 'Length' -NewKeyName 'Size'

            Name Value
            ---- -----
            Size 158
            Size 4128
            Size 1046
            Size 253

    .example
        PS>
        🐒> ls . -file | select -First 4 | %{
        $hash1 = $_ | Lookup 'Length' -NewKeyName 'Size'
        $hash2 = $_ | Lookup 'LastWriteTime' -NewKeyName 'Updated'
        $merged = Join-Hashtable $hash1 $hash2
        $merged
        } | ft -AutoSize

            Name    Value
            ----    -----
            Updated 4/11/2021 4:51:46 PM
            Size    158
            Updated 10/9/2021 6:16:03 PM
    .example
        PS>
            ls . -file | select -First 4 | %{
            $hash1 = $_ | Lookup 'Length' -NewKeyName 'Size'
            $hash2 = $_ | Lookup 'LastWriteTime' -NewKeyName 'Updated'
            $merged = Join-Hashtable $hash1 $hash2
            $merged
            } | %{ [pscustomobject]$_  }

                Updated               Size
                -------               ----
                4/11/2021 4:51:46 PM   158
                10/9/2021 6:16:03 PM  4128
                4/28/2021 10:01:59 PM 1046
    .example
        (ls . -file)[0] | Lookup 'Length' -NewKeyName 'Size'
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
    [OutputType('System.Collections.Hashtable')]
    [cmdletbinding(DefaultParameterSetName = 'FromPipe')]
    # [cmdletbinding(DefaultParameterSetName = 'FromParam')]
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

    }
    process {
        $hash = @{}
        if ( [string]::IsNullOrWhiteSpace( $NewKeyName ) ) {
            $FinalKeyName = $LiteralPropertyName
        } else {
            $FinalKeyName = $NewKeyName
        }

        $dbg = [ordered]@{
            NewKeyName          = $NewKeyName
            LiteralPropertyName = $LiteralPropertyName
            FinalKeyName        = $FinalKeyName
        }
        # $dbg | Out-Default | Out-String | Write-Debug

        $newValue = $InputObject[ $LiteralPropertyName ] ?? "`u{2400}"
        # $dbg['NewProp1'] = $newValue
        $newValue ??= $InputObject.$LiteralPropertyName
        $newValue ??= "`u{2400}"

        # $dbg['NewProp2'] = $newValue
        # $dbg['FinalKeyName'] = $FinalKeyName
        # $dbg['LastValue'] = $newValue
        # $dbg | dict | Out-String | Write-Debug

        $FinalValue = $InputObject[$FinalKeyName] ?? (
            $InputObject.PsObject.Properties
            | Where-Object Name -EQ $LiteralPropertyName
            | ForEach-Object Value
        )
        # $dbg['FinalValue'] = $FinalValue
        # $dbg | Out-Default | Write-Debug
        $hash.add( $FinalKeyName, $FinalValue )
        return $hash
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
    $now = Get-Date
    $source1 = [pscustomobject]@{
        Species = 'Cat'
        Name    = 'Henry'
    }
    $source2 = $now
    $Source3 = Get-Item .

    $now | dict -LiteralInclude 'Day' -ea continue
    h1 'this has null key names'
    $now | Lookup -LiteralPropertyName Day -Debug
}

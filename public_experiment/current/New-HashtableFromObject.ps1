#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-HashtableFromObject'
        'New-HashtableLookup'

    )
    $experimentToExport.alias += @(
        'To->Hashtable'
        'ConvertTo-Hashtable'
        'Lookup'
    )
}


function New-HashtableLookup {
    <#
    .SYNOPSIS
        look up key->value pairs, return/create hash,  optionally rename key
    .notes
        name?
        Dpair, Lookup, Prop, HashProp, pair? AttributePair, New

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
    [cmdletbinding()]
    param(

        # regex patterns to include property, otherwise you get all
        [Parameter(
            ParameterSetName = 'FromPipe',
            Mandatory, ValueFromPipeline)]
        [Parameter(
            ParameterSetName = 'FromParam',
            Mandatory, Position = 0)]
        [string]$InputObject,

        [Alias('Property', 'Name')]
        [Parameter(
            ParameterSetName = 'FromPipe',
            Mandatory, Position = 0)]
        [Parameter(
            ParameterSetName = 'FromParam',
            Mandatory, Position = 1)]
        [string]$LiteralPropertyName,

        # rename the key
        # [Alias()]
        [Parameter(
            ParameterSetName = 'FromPipe',
            Mandatory, Position = 1)]
        [Parameter(
            ParameterSetName = 'FromParam',
            Mandatory, Position = 2)]
        [string]$NewKeyName
    )

    begin {
        '- [ ] finish by asking for group-object tips and hash key thingy
        - [ ] dynamically generated calculated props' | Write-Warning

        @'
    rewrite, compare to
        <C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\recycle\new_obj.left.ps1>
        C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\recycle\new_object_right.ps1>
        '
'@ | Write-Warning

    }
    process {
        $newKey = $NewKeyName ?? $LiteralPropertyName




        # ! $hash1.ContainsKey('name')
        # if(!($InputObject.))
        # $newValue = $InputObject
        $hash = @{}
        $kvalue = $InputObject[$LiteralPropertyName]
        @{
            Key = $NewKeyName ?? $LiteralPropertyName
        }
    }
    end {
    }


}

function New-HashtableFromObject {
    <#
    .synopsis
        Quickly create a hashtable from selected properties, filtered by regex
    .description
        #1 stable: move to Ninmonkey.Console
       .modes

        - default includes all properties
        - else -IncludeProperty only includes matching

        Afterwards, excludeproperty will optionally remove more

        - it currently does not recursively visit properties
    .notes
        future:
            - [ ] auto-sort key names
    .example
        PS> ls .  | select -first 1 | % gettype | New-HashtableFromObject
    .example
        PS> get-date | dict Hour, day\b
        🐒> get-date | dict Hour, day\b

            Name      Value
            ----      -----
            Day       19
            Hour      10
            TimeOfDay 10:06:17.6551716
    .link
        Dev.Nin\Assert-HashtableEqual
    .link
        Dev.Nin\Sort-Hashtable
    .link
        Dev.Nin\New-HashtableFromObject
    .link
        Dev.Nin\New-HashtableLookup
    .outputs
          [hashtable] or [Collections.Specialized.OrderedDictionary]

    #>
    # linter complains about type 'ordered' not being returned
    # but [ordered] isn't a true data type in Pwsh, maybe a linter rule bug
    # [outputtype('Collections.Specialized.OrderedDictionary')]
    [Alias('
        To->Hashtable',
        'ConvertTo-Hashtable'
        # 'Dict' # defined in profile
    )]
    [outputtype('hashtable')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Source object
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # regex patterns to include property, otherwise you get all
        [Alias('RegexInclude')]
        [Parameter(
            # ParameterSetName = 'IncludeFilter',
            Position = 0)]
        [string[]]$IncludeProperty,

        # regex patterns to exclude names
        [Alias('RegexExclude')]
        [Parameter(
            Position = 1)]
        [string[]]$ExcludeProperty,


        # Literal exclude is kind of redundant, so aliases for literal have no conflict?
        # [Alias('LitProp', 'Prop', 'LitInclude')]
        [Alias('Prop', 'LitInclude')]
        [Parameter()]
        [string[]]$LiteralInclude
    )

    begin {

    }
    process {
        $Hash = [ordered]@{}
        [string[]]$PropNames = $InputObject.psobject.properties.Name | Sort-Object -Unique
        [string[]]$FilteredNames = @()

        # wait what?
        # $PropNames | ForEach-Object {
        #     $curName = $_
        # }

        $PropNames | str csv -sort | Write-Color gray | Join-String -op 'Initial Props: ' | Write-Debug


        if ($LiteralInclude.count -gt 0) {
            Write-Warning 'Regex works, mixing Literal needs a rework, otherwise regex started with all props, and literal didn''t '
            $AllPropNames = @()
        }


        if (! $IncludeProperty ) {
            # $filteredNames = $PropNames
        } else {
            # todo: refactor using AnyTrue or AnyFalse , maybe in Utility
            # $ErrorActionPreference = 'stop'
            $filteredNames = $PropNames | Where-Object {
                $curName = $_
                foreach ($pattern in $IncludeProperty) {
                    #do I try catch on the innermost test?
                    if ($curName -match $Pattern) {
                        $true; return;
                    }
                }
            }
            # $ErrorActionPreference = 'stop'
        }
        $filteredNames | str csv -sort | Write-Color gray | Join-String -op 'Included Props: ' | Write-Debug
        if (! $ExcludeProperty ) {
            $filteredNames = $filteredNames
        } else {
            # todo: refactor using AnyTrue or AnyFalse , maybe in Utility
            $filteredNames = $filteredNames | Where-Object {
                $curName = $_
                foreach ($pattern in $ExcludeProperty) {
                    if ($curName -match $Pattern) {
                        $false; return;
                    }
                }
                $true; return;
            }
        }

        $filteredNames | str csv -sort | Write-Color gray | Join-String -op 'Included Props: ' | Write-Debug

        # todo: if foreach->try swallows errors, then throw it here
        if (! $ExcludeProperty -or (! [string]::IsNullOrEmpty($ExcludeProperty))) {
            $filteredNames = $filteredNames
        } else {
            # todo: refactor using AnyTrue or AnyFalse would simlify emitting more than one bool
            $filteredNames = $filteredNames | Where-Object {
                $curName = $_
                foreach ($pattern in $ExcludeProperty) {
                    if ($curName -match $Pattern) {
                        return $false
                    }
                }
                return $true
            }
        }

        # literal include last
        $LiteralInclude | ForEach-Object {
            Write-Debug "iter: $_"
            # if ($PropNames -contains $_) {
            if ($AllPropNames -contains $_) {
                $filteredNames += $_
            }
        }


        if ($false) {
            $filteredNames += @(
                $LiteralInclude | Where-Object {
                    $PropNames -contains $_
                }
            )
        }
        #     $PropNames | ?{ $_ -in $LitInclude }
        # )
        # $PropNames | Where-Object { $_ -in $LitInclude }
        # $filteredNames | Sort-Object -Unique # future: get unique without sorting
        $filteredNames | str csv -sort | Write-Color gray | Join-String -op 'Excluded Props: ' | Write-Debug

        h1 "$($FilteredNames.count)" | Write-Debug

        $filteredNames | ForEach-Object {
            $curName = $_
            $targetObj = $InputObject.psobject.properties

            # needs verbose null test if PS5
            if ($targetObj.Name -notcontains $curName) {
                Write-Error -ea continue -Message "Error reading property '$curName'" -TargetObject $targetObj
            }
            <# check for
                > index operation failed; the array index evaluated to null
            #>
            $hash[ $curName ] = ($targetObj[ $curName ])?.Value
        }
        if ($Hash.Keys.Count -eq 0) {
            Write-Error -Message 'Zero Properties found'
        }
        $hash
    }

    end {
    }
}

if (! $experimentToExport) {
    'HI'
    Get-Date | New-HashtableFromObject -Debug -RegexInclude 'day', '.*year', 'kind' -ExcludeProperty '.*of.*'
    $h = Get-Date | New-HashtableFromObject -Debug -RegexInclude 'day', '.*year', 'kind' -ExcludeProperty '.*of.*'
    hr$
    $h
    hr
    Get-Date | New-HashtableFromObject
    <#
    Import-Module Dev.Nin -Force
    Err -Clear ; hr -fg magenta; br 2
    Get-Date | New-HashtableFromObject 'name*'
    #>
    # ...
}

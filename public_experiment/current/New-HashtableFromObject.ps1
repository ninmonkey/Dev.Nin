#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-HashtableFromObject'

    )
    $experimentToExport.alias += @(
        'To->Hashtable'
        'ConvertTo-Hashtable'
    )
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
    [Alias('
        To->Hashtable',
        'ConvertTo-Hashtable'
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

        if (! $IncludeProperty ) {
            $filteredNames = $PropNames
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

        # literal include last
        $LiteralInclude | ForEach-Object {
            Write-Debug "iter: $_"
            if ($PropNames -contains $_) {
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

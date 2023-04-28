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

function New-HashtableFromObject {
    <#
    .synopsis
        Quickly create a hashtable from selected properties, filtered by regex
    .description
        stable: move to Ninmonkey.Console
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
        [string[]]$AllPropNames = $InputObject.psobject.properties.Name | Sort-Object -Unique
        [string[]]$FilteredNames = @()
        $AllPropNames | str csv -sort | Write-Color gray | Join-String -op 'Initial Props: ' | Write-Debug

        if ($LiteralInclude.count -gt 0) {
            Write-Warning 'Regex works, mixing Literal needs a rework, otherwise regex started with all props, and literal didn''t '
            $AllPropNames = @()
        }

        if (! $IncludeProperty -or ([string]::IsNullOrEmpty($IncludeProperty))) {
            $filteredNames = $AllPropNames | Where-Object { ! [string]::IsNullOrEmpty($_) }
        } else {
            $filteredNames = $AllPropNames | Where-Object {
                $curName = $_
                foreach ($pattern in $IncludeProperty) {
                    if ($pattern -eq '*' -or $pattern -eq [string]::Empty -or [string]::IsNullOrEmpty($pattern) ) {
                        return $true
                    }
                    try {
                        if ($curName -match $Pattern) {
                            return $true
                        }
                    } catch {
                        # no-op
                    }
                }
                $false
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

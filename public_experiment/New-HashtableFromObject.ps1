#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-HashtableFromObject'

    )
    $experimentToExport.alias += @(
        'To->Hashtable'
        'ConvertTo-Hashtable'
        # 'Filter->Hashtable',
     
    )
}

function New-HashtableFromObject {
    <#
    .synopsis
        Quickly create a hashtable from selected properties, filtered by regex
    .description
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
            Position = 0
        )]
        [string[]]$IncludeProperty,

        # regex patterns to exclude names
        [Alias('RegexExclude')]
        [Parameter(
            # ParameterSetName = 'IncludeFilter',
            Position = 1
        )]
        # [Parameter(
        #     Position = 0
        # )]
        [string[]]$ExcludeProperty
    )

    begin {
    }
    process {
        $Hash = [ordered]@{}
        $PropNames = $InputObject.psobject.properties.Name | Sort-Object -Unique

        $PropNames | ForEach-Object {
            $curName = $_

        }

        $PropNames | str csv -sort | Write-Color gray | Join-String -op 'Initial Props: ' | Write-Debug

        if (! $IncludeProperty ) {
            $filteredNames = $PropNames
        } else {
            # todo: refactor using AnyTrue or AnyFalse , maybe in Utility
            $filteredNames = $PropNames | Where-Object {
                $curName = $_
                foreach ($pattern in $IncludeProperty) {
                    if ($curName -match $Pattern) {
                        $true; return;
                    }
                }
            }
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
        $filteredNames | str csv -sort | Write-Color gray | Join-String -op 'Excluded Props: ' | Write-Debug
        $filteredNames | ForEach-Object {
            $curName = $_
            $targetObj = $InputObject.psobject.properties
            $hash[ $curName ] = ($targetObj[ $curName ])?.Value
            # $hash[ $curName ] = $InputObject.psobject.properties[ $curName ].Value
        }
        # $InputObject
        # Wait-Debugger
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
    # ...
}

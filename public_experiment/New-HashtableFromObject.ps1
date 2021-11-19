#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-HashtableFromObject'
        'Select-HashtableKey'
    )
    $experimentToExport.alias += @(
        'To->Hashtable'
        'ConvertTo-Hashtable'
        # 'Filter->Hashtable',
     
    )
}

function Select-HashtableKey {
    <#
    .synopsis
        Create a hashtble by filtering keys
    .description
       .
    .outputs
        [hashtable]
    #>    
    [Alias(
        # 'Filter->Hashtable',
        'Select-HashtableKey'
    )]
    [outputtype('hashtable')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Source object
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [hashtable]$InputObject,

        #Docstring

        [Parameter(Mandatory, Position = 1)]
        [string[]]$IncludeRegex
    )
    begin {
        <#
        todo test case
        
                $a = @{'a' = 34; 'ze' = 55}
                $b = @{'a' = 'good' ; q = 'bad'}
                $c = [pscustomobject]$b | New-HashtableFromObject -IncludeProperty 'a'
                hr
                Join-Hashtable $a $c
                hr
                $c

        #>
        
    }
    process {
        [hashtable]$newHash = @{}

        # todo: refactor using AnyTrue or AnyFalse , maybe in Utility
        $filteredKeys = $InputObject.Keys.clone() | Where-Object {
            $curName = $_
            foreach ($pattern in $IncludeRegex) {
                if ($curName -match $Pattern) {
                    $false; return;
                }
            }
            $true; return;
        }
        'Original Keys {0}' -f @(
            $InputObject.Keys | str csv -SingleQuote -Sort
        ) | Write-Debug
        'Filtered Keys: {0}' -f @(
            $filteredKeys | str csv -SingleQuote -Sort
        ) | Write-Debug
        
        $filteredKeys | ForEach-Object {
            $curKey = $_            
            $newHash[ $curKey ] = $InputObject[ $curKey ]            
        }
        $NewHash
        return 

        $UpdateHash.GetEnumerator() | ForEach-Object {
            $anyMatch = 
            $NewHash[ $_.Key ] = $_.Value
        }
        $NewHash

        return 



        # todo: refactor using AnyTrue or AnyFalse , maybe in Utility
        $InputObject.keys.clone() | ForEach-Object {
            $curKey = $_
            $matchesAny = $IncludeRegex | Where-Object {
                $curName = $_
                foreach ($curRegex in $IncludeRegex) {
                    if ($curKey -match $curRegex) {
                        $true; return;
                    }
                }
            }
            "key '$curKey' matches any? $matchesAny" | Write-Debug
        }
    }

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

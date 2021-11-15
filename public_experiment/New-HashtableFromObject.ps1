#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'F'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function New-HashtableFromObject {
    <#
    .synopsis
        Stuff
    .description
       .modes
        
        - default includes all properties
        - else -IncludeProperty only includes matching

        Afterwards, excludeproperty will optionally remove more        
    .example
          .
    .outputs
          [string | None]
    
    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Alias('InputObject')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$HashTable,

        # regex patterns to include property, otherwise you get all
        [Alias('RegexInclude')]
        [Parameter(
            ParameterSetName = 'IncludeFilter',            
            Position = 0, Mandatory
        )]
        [string[]]$IncludeProperty,
        
        # regex patterns to exclude names
        [Alias('RegexExclude')]
        [Parameter(
            ParameterSetName = 'IncludeFilter',
            Position = 1
        )]
        [Parameter(
            Position = 0
        )]        
        [string[]]$ExcludeProperty
    )
    
    begin {
    }
    process {
        if ( ! $IncludeProperty ) {
            $IncludeProperty = '.*'
        }
        [ordered]@{

        }
        $InputObject
        
        
    }   
    end {
    }
}

if (! $experimentToExport) {
    'HI'
    # ...
}
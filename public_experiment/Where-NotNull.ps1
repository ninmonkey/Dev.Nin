#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Where-NotNull'
    )
    $experimentToExport.alias += @(
        'Filter->NotNull'
    )
}

function Where-NotNull {
    [alias('Filter->NotNull')]
    <#
    .synopsis
        filters out null values
    .description
       .
    .example
         PS> 'a', $null | Get-RuneDetail
            Error: Cannot bind argument to parameter 'InputText' because it is an empty string

         PS> 'a', $null | Where-NotNull | Get-RuneDetail
            0x61 = 'a'
    .outputs
          [object]
    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(ValueFromPipeline)]
        [object]$InputObject,

        [Parameter(Position = 0)]
        [validateSet('TrueNull', 'NullOrEmpty', 'NullOrWhiteSpace')]
        [string]$FilterBy = 'TrueNull'
    )
    
    begin {
    }
    process {
        # true null

        switch ($FilterBy) {
            'TrueNull' {
                if ($null -eq $InputObject) {
                    return
                }
            }
            'NullOrEmpty' {
                if ( [string]::IsNullOrEmpty( $InputObject ) ) {
                    return
                }
            }
            'NullOrWhiteSpace' {
                if ( [string]::IsNullOrWhiteSpace( $InputObject ) ) {
                    return
                }
            }
            default {
                break 
            }            
        }

        $InputObject
        
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
}
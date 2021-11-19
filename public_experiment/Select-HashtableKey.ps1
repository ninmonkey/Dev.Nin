#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Select-HashtableKey'
    )
    $experimentToExport.alias += @(
        
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
    )]
    [outputtype('hashtable')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Source object
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [hashtable]$InputObject,

        #Docstring

        [Parameter(Position = 1)]
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
        $selectedKeys = $InputObject.Keys.clone() | Where-Object {
            $curName = $_
            foreach ($pattern in $IncludeRegex) {
                if ($curName -match $Pattern) {
                    $true; return;
                }
            }
            $false; return;
        }
        'Original Keys {0}' -f @(
            $InputObject.Keys | str csv -SingleQuote -Sort
        ) | Write-Debug
        'Filtered Keys: {0}' -f @(
            $selectedKeys | str csv -SingleQuote -Sort
        ) | Write-Debug
        
        $selectedKeys | ForEach-Object {
            $curKey = $_            
            $newHash[ $curKey ] = $InputObject[ $curKey ]            
        }
        $NewHash
        
        return 
    }
}

if (! $experimentToExport) {
    # ...
}
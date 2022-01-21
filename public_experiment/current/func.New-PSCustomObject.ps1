#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-NinPSCustomObject'
    )
    $experimentToExport.alias += @(
        'Obj'
    )
}

function New-NinPSCustomObject {
    <#
        .synopsis
            sugar for the command line -- ix: [pscustomobject]@{a=1}
        .notes
            .
        .example
            PS> @{name='cat'} | Obj
        .example
            PS> # some types are a round trip
                $error |  Inspect->ErrorType | obj | dict | obj | dict
        .link
            dev.nin\New-HashtableFromObject
        .link
            dev.nin\New-HashtableLookup
        #>
    [Alias('Obj')]
    [outputtype([System.Management.Automation.PSObject] )]
    [cmdletbinding()]
    param(
        # hastable[s]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [hashtable]$InputHashTable
    )
    begin {
    }
    process {
        [pscustomobject]$InputHashTable
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
}

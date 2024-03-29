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
            Create [pscustomobject]s from hashtables
        .notes
            .
            Originally this was 'Dev.Nin\New-TextObject . Then functionality was added.
        .example
            PS> @{name='cat'} | Obj
        .example
            PS> # some types are a round trip
                $error |  Inspect->ErrorType | obj | dict | obj | dict
        .link
            dev.nin\New-TextObject
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
        # switched to obj, so strings auto coerce easier
        [Alias('Hashtable')]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject

    )
    begin {
    }
    process {

        if ($InputObject -is 'hashtable') {
            $InputObject['PSTypeName'] = 'DevNin.Obj'
        }
        # future
        # should include when the input is an object?
        $InputObject.GetType().FullName
        | Write-Debug # prints: [System.Collections.Specialized.OrderedDictionary]
        $tinfo = $InputObject.GetType().FullName

        switch ($Tinfo) {
            { $_ -is 'System.String' -or $_ -is 'System.Char' } {

                [pscustomobject]@{
                    PSTypeName = 'DevNin.StringObject'
                    Name       = $InputObject
                }
            }
            default {
                [pscustomobject]$InputObject
            }
        }
    }
    end {
        Write-Warning 'this is wrong code, this is the new-textobject version, this one should be able to pipe'
    }
}

if (! $experimentToExport) {
    # ...
}

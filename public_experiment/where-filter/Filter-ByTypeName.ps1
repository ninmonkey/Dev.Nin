#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Filter-ByTypeName'
    )
    $experimentToExport.alias += @(
        'Filter->ByType' # 'Filter-ByTypeName'
        'Test-TypeName' # 'Filter-ByTypeName'
    )
}

function Filter-ByTypeName {
    <#
    .synopsis
        include, or exclude, based on type names
    .notes
    .
    .example
        PS> Verb-Noun -Options @{ Title='Other' }
    #>
    # [outputtype( [string[]] )]
    # [Alias('x')]
    [cmdletbinding()]
    param(

        # docs
        # [Alias('y')]
        [parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject,

        # required types
        [Parameter(Position = 0)]
        [ArgumentCompletions(
            'String', 'Array', 'Int', 'Hashtable'
        )]
        [string[]]$IsType,

        # excluded types
        [Parameter(Position = 1)]
        [ArgumentCompletions(
            'String', 'Array', 'Int', 'Hashtable'
        )]
        [string[]]$IsNotType,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            # AlignKeyValuePairs = $true
            # Title              = 'Default'
            # DisplayTypeName    = $true
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {


        foreach ($t_name in $IsType) {
            $InputObject -is $t_name
        }

        if ($IsType.count -eq 0) {
            $stateGood_isRightType = $true
        }
        # foreach($t_name in $IsType) {
        #     if($t_name )
        # }

        if ($IsNotType.count -le 0) {
            $stateGood_NotType = $true
        }
    }
    end {
    }
}



if (! $experimentToExport) {
    # ...
}

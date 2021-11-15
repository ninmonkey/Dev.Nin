#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Out->Picker'
    )
    $experimentToExport.alias += @(
        'Pick'
        'Pipe->Pick'
    )
}


function Out->Picker {
    <#
    .synopsis 
        Throw in a pipeline to quickly filter, also saves as $picker, if needed
    .description
    #>
    end {
        $global:picks ??= $Input | fzf -m
        $global:picks
    }
}

function BreaksWhenParam-Out->Picker {
    <#
    .synopsis 
        Throw in a pipeline to quickly filter, also saves as $picker, if needed
    .description
    #>
    [Alias(
        'Pick',
        'Pipe->Pick'
    )]
    # [cmdletbinding()]
    param(
        # always pick something
        [Parameter()]
        [switch]$Force
    )
    end {
        if ($Force) {
            $global:picks = $null
        }
        $global:picks ??= $Input | fzf -m 
        $global:picks
    }
}

if (! $experimentToExport) {
    # ...
}
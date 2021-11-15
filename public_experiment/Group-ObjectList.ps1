#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Group-ObjectList'
    )
    $experimentToExport.alias += @(
        'GroupByCount'
    )
}

function Group-ObjectList {
    <#
    .synopsis
        collects items and emits them in groups **without full listing**
    .notes
        Need a real name
    .description
        0..6 GroupByCount 3 returns:
            @(
                0..2
                3..5
                6
            )        

    .example
            0..6 GroupByCount 3 returns:
            @(
                0..2
                3..5
                6
            )
          .
    .outputs
          [object[]]
    
    #>
    [Alias('GroupByCount')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )
    
    begin {
       
    }
    process {
       
        throw 'NYI'
    }
    end {
       
    }
}

if (! $experimentToExport) {
    # ...
}
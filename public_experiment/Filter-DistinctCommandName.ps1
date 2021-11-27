#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Filter-DistinctCommandNamed'
    )
    $experimentToExport.alias += @(
        'Filter->DistinctCommandName'
        # 'A'
    )
}

function Filter-DistinctCommandName {
    <#
    .synopsis
        Pipe a list of commands, aliases, etc. get distinct resolved command
    .description
        is this filter? or reduce? or map?
       .
    .example
          .
    .outputs
          [string | None]

    #>
    [Alias('Filter->DistinctCommandName')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$CommandName,

        [Parameter()]
        [switch]$IgnoreAlias


    )

    begin {
    }
    process {
        $PreserveAlias = ! $IgnoreAlias
        Get-Command $CommandName (_enumerateMyModule)
        | rescmd -PreserveAlias:$PreserveAlias -QualifiedName
        | Sort-Object
    }
    end {
    }
}

if (! $experimentToExport) {
    # ...
}
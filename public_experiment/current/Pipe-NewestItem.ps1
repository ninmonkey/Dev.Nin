
#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Pipe-Newest'
    )
    $experimentToExport.alias += @(
        # 'Pipe->Newest'

    )
}

<#
# better verb clarity using
    Find->          [ Get-<noun>Item ]
        search for items,
    Filter->        [ where-<condition> ]
        remove using conditions,
        pipe already exists

    Peek->
        acts on the end of input, then may
        [1] quit without any return value, or
        [2] choose items in 'fzf' while previewing using peek
            ( it's 'fzf -m' with preview on)


#>

function Filter-Newest {
    <#
    .SYNOPSIS
    find, by dates.

    .DESCRIPTION
    Long description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    # 'NYI. Verb Peek-> is essentially composable filters or maps'
    param(
        # []
    )
    Write-Warning 'nyi'
}

if (! $experimentToExport) {
    # ...
}

$experimentToExport.function += @(
    'Test-AllTrue'
    'Test-AnyTrue'
)
$experimentToExport.alias += @(
    # 'All' # breaks pester
    # 'Any'
)


function Test-AnyTrue {
    <#
    .synopsis
    are any one of the expressions true ?
    #>
    [Alias('?Any')] # 'Any'
    [CmdletBinding()]
    param()

    Write-Error 'nyi' -Category NotImplemented
}

function Test-AllTrue {
    <#
    .synopsis
    are all expressions true ?
    .example
        PS> # Do they evaluate as true?

            @($true, $false) | ?All
            @($true, $false) | ?All -AreTrue
            # false

        PS> # filter  evaluate as true?
            #
        ... | ?All -NotNull
    #>
    [Alias('?All')] # 'all'
    [CmdletBinding()]
    param(

    )


    Write-Error 'nyi' -Category NotImplemented
}

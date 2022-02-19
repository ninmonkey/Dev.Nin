$experimentToExport.function += @(
    'Test-AllTrue'
    'Test-AnyTrue' #6 #1
)
$experimentToExport.alias += @(
    # 'All' # breaks pester
    # 'Any'
)


function Test-AnyTrue {
    <#
    .synopsis
    are any one of the expressions true ?
    .link
        functional\Test-Any
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
    .LINK
        functional\Test-All
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

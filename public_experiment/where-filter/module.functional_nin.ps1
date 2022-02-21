#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'Test-AllTrue'
        'Test-AnyTrue'
        'Test-AnyFalse'

        'Test-AllTrue'
        'Test-AllFalse'
        # 'Test-AnyTrue' #6 #1
        # ''
    )
    $experimentToExport.alias += @(
        # 'All' # breaks pester
        # 'Any'
        # 'Test-AllTrue'

    )
}

# New-Alias 'Test-AllTrue' -Value 'functional\Test-All' -Description 'Will be rewriting module "functional", currently a wrapper'

function Test-AnyTrue {
    <#
    .synopsis
        at least one expression is true
    .notes
        future:
            - [ ] alias versions like 'Assert-AnyTrue' which throw if false
    .link
        functional\Test-Any
    #>
    [OutputType([boolean])]
    Param()

    foreach ($e in $input) {
        if ($e) {
            return $true
        }
    }
    return $false
}

function Test-AnyFalse {
    <#
    .synopsis
        at least one expression is false
    .link
        functional\Test-Any
    #>
    [OutputType([boolean])]
    Param()

    foreach ($e in $input) {
        if (! $e) {
            return $true
        }
    }
    return $false
}

function Test-AllFalse {
    <#
    .synopsis
        All expressions evaluate to true
    .link
        functional\Test-All
    #>
    [OutputType([boolean])]
    Param()

    foreach ($e in $input) {
        if ($e) {
            return $false
        }
    }
    return $true
}
function Test-AllTrue {
    <#
    .synopsis
        All expressions evaluate to true
    .link
        functional\Test-All
    #>
    [OutputType([boolean])]
    Param()

    foreach ($e in $input) {
        if (-not $e) {
            return $false
        }
    }
    return $true
}

# function Test-AnyTrue {
#     <#
#     .synopsis
#     are any one of the expressions true ?
#     .link
#         functional\Test-Any
#     #>
#     [Alias('?Any')] # 'Any'
#     [CmdletBinding()]
#     param()

#     Write-Error 'nyi' -Category NotImplemented
# }

# function Test-AllTrue {
#     <#
#     .synopsis
#     are all expressions true ?
#     .LINK
#         functional\Test-All
#     .example
#         PS> # Do they evaluate as true?

#             @($true, $false) | ?All
#             @($true, $false) | ?All -AreTrue
#             # false

#         PS> # filter  evaluate as true?
#             #
#         ... | ?All -NotNull
#     #>
#     [Alias('?All')] # 'all'
#     [CmdletBinding()]
#     param(

#     )


#     Write-Error 'nyi' -Category NotImplemented
# }


if (! $experimentToExport) {
    # ...
}

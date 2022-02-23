#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Test-AnyTrue'
        'Test-AnyFalse'
        'Test-AllTrue'
        'Test-AllFalse'

        # 'Assert-AnyTrue'
        # 'Assert-AnyFalse'
        # 'Assert-AllTrue'
        # 'Assert-AllFalse'
        # #6 #1
    )
    $experimentToExport.alias += @(


    )
}

# Assert-AnyTrue {
#     # should output be the union [ $null | Exception ]
#     [OutputType([boolean])]
#     Param()

#     if (Test-AnyTrue $Input) {
#         return
#     }

#     # todo: ask for advice on exception throwing
#     $errorRecord = [ErrorRecord]::new(
#         <# exception: #>
#         [Exception]::new(
#             <# message: #> 'AssertException: Test-AnyTrue was false'),
#         <# errorId: #> 'AssertionFailed.Test-AnyTrue',
#         <# errorCategory: #> 'InvalidResult',
#         <# targetObject: #> 'input')
#     $PSCmdlet.ThrowTerminatingError(
#         <# errorRecord: #> $errorRecord)
# }

function Test-AnyTrue {
    <#
    .synopsis
        at least one expression is true
    .notes
        future:
            - [ ] alias versions like 'Assert-AnyTrue' which throw if false
    .link
        Dev.Nin\Test-AnyTrue
    .link
        Dev.Nin\Test-AnyFalse
    .link
        Dev.Nin\Test-AllTrue
    .link
        Dev.Nin\Test-AllFalse
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
        Dev.Nin\Test-AnyTrue
    .link
        Dev.Nin\Test-AnyFalse
    .link
        Dev.Nin\Test-AllTrue
    .link
        Dev.Nin\Test-AllFalse
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
        All expressions evaluate to false
    .link
        Dev.Nin\Test-AnyTrue
    .link
        Dev.Nin\Test-AnyFalse
    .link
        Dev.Nin\Test-AllTrue
    .link
        Dev.Nin\Test-AllFalse
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
        Dev.Nin\Test-AnyTrue
    .link
        Dev.Nin\Test-AnyFalse
    .link
        Dev.Nin\Test-AllTrue
    .link
        Dev.Nin\Test-AllFalse
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
if (! $experimentToExport) {
    # ...
}

#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-DebugErrorCycle'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

Function Invoke-DebugErrorCycle {
    <#
    .SYNOPSIS
        example to test, only print *new* errors
    .DESCRIPTION
        Err -Reset only marks current errors as read
        so they still exist. better than using $error.Clear() on a code loop
    .EXAMPLE
        PS> Invoke-DebugErrorCycle -ScriptBlock {
        $args | ForEach-Object{
            10 / $_
        }
        } -InputObject 10, 0
    #>
    param(
        # what to try
        [parameter(Mandatory, Position = 0)]
        [scriptBlock]$ScriptBlock,

        # list of inputs
        [alias('InputObject')]
        [parameter()]
        [object[]]$Args
    )

    begin {
    }
    # [1] example of error chunk cycles, without
    # removing errors
    # error cycles

    process {
        err -Reset # preserve errors
        hr -fg 'magenta'
        br 3

        & $ScriptBlock @Args

        showErr -Recent
        hr -fg 'orange'
    }
}





if (! $experimentToExport) {

    # ...
}

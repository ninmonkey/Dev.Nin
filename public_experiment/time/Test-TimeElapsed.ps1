#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Test-TimeElapsed'
    )
    $experimentToExport.alias += @(
        # 'Assert-TimeElapsed'  # 'Test-TimeElapsed'
    )
}


function Test-TimeElapsed {
    <#
    .synopsis
        quickly test whether an amount of time has elapsed
    .description
        Test-HasTimeElapsed?
    .notes
        todo:
            - [ ] is this the right exception
            - [ ] Dev.Nin\New-LabeledTimer
    .link
        Dev.Nin\New-LabeledTimer
    .outputs
        [Boolean] unless using alias
        'Assert-TimeElapsed' throws on error
    #>
    # [Alias('Assert-TimeElapsed')]
    [CmdletBinding()]
    param(
        # when did it start? relative now
        [Alias('Begin')]
        [Parameter(Mandatory, Position = 0)]
        [datetime]$StartTime,

        # todo: arg transformation RelativeTs #5e
        [Alias('RelativeTs')]
        [Parameter(Mandatory, Position = 1)]
        [object]$RelativeTimespan
    )
    $RelativeTimespan = RelativeTs -RelativeText $RelativeTimespan

    $now = [datetime]::Now
    $delta = $now - $StartTime
    return ($delta -ge $RelativeTimespan)
    # $delta = RelativeTs -RelativeText $RelativeTimespan

}


if (! $experimentToExport) {
    # ...
}

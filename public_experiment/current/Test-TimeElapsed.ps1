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

        [Alias('RelativeTs')]
        [Parameter(Mandatory, Position = 1)]
        [object]$RelativeTimespan
    )


    $now = [datetime]::Now
    $delta = $now - $StartTime
    return ($delta -ge $RelativeTimespan)
    # $delta = RelativeTs -RelativeText $RelativeTimespan

}


if (! $experimentToExport) {
    # ...
}

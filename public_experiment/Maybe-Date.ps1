$experimentToExport.function += @(
    'Maybe-GetDatetime'
)
$experimentToExport.alias += @(
    'ConvertTool💻-MaybeDate?'
    'Get-MaybeDate?'
    '?Date'
)

$script:__devGist_cache = $null # __doc__: replace with MiniModules\LazyCache

function Maybe-GetDatetime {
    <#
    .synopsis
        try to create a [datetime] instance, on failure, return the original string
    .description
        ..
    .notes
        .
    .example
            PS> '2020-06-07T22:14:32Z' | Maybe-GetDatetime
            PS> Maybe-GetDatetime '020-06-07T22:14:32Z'
    .example
        PS> gcm -Module (_enumerateMyModule) | Find-CommandWithParameterAlias | ft -AutoSize
    #>
    [ALias('ConvertTool💻-MaybeDate?', 'Get-MaybeDate?', '?Date')]
    [cmdletbinding(PositionalBinding = $false)]
    param (
        #
        [Parameter(
            Position = 0,
            Mandatory, ValueFromPipeline)]
        [string]$DateString,

        # optionally declare format
        [Parameter()]
        [string]$FormatString
    )
    begin {
        Write-Debug "FormatString: '$FormatString'"
    }
    process {
        try {
            if ([string]::IsNullOrWhiteSpace($FormatString)) {
                [datetime]$DateString
            } else {
                Write-Error 'formatstring NYI'
                # [datetime]::ParseExact($DateString, $FormatString)
            }
        } catch {
            $DateString
        }
    }
    end {}

}

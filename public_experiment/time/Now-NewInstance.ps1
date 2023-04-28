#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'New-TimeItem'  # ''
    )
    $experimentToExport.alias += @(
        # ''
        # if($true -and $ExtraImport) {
        #     'Now' # New-TimeItem
        # }
    )
}

function New-TimeItem {
    <#
    .synopsis
        sugar for time related things
    .notes
        .
    Now -Str 'o'

    first: see:
        C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\ideas\time-formatting.md



    .example
        PS> Verb-Noun -Options @{ Title='Other' }
    .link
        https://docs.microsoft.com/en-us/dotnet/api/System.Diagnostics.Stopwatch?view=net-6.0
    .outputs
        depends a lot.
        [datetime] | [string] | [timespan]
    #>
    [Alias(
        'Now',
        'Time->Now'
        # defined elswhere: 'Time->Watch'
    )]
    [cmdletbinding()]
    param(
        # docs
        # [Alias('y')
        [Alias('Arg1')]
        [parameter(Position = 0, ValueFromPipeline)]
        [object]$InputObject,


        # decide output types
        [Alias('-As')]
        [ArgumentCompletions(
            'Date',
            'Dt', # 'DateTime' # it's implicit anyway
            'Time',
            'String', 'Str'
        )]
        [Parameter()]
        [Switch]$TypeName,

        # extra options
        [Parameter()][hashtable]$Options
    )
    begin {

        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        [hashtable]$Config = @{
            'FormatString' = 'o'
            # AlignKeyValuePairs = $true
            # Title              = 'Default'
            # DisplayTypeName    = $true
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
    }
    process {

        <#
        acceptable values
            'Date',
            'Dt', 'DateTime'
            'Time',
            'String', 'Str'
        #>
        # is stopwatch crazy?
        switch ($TypeName) {
            # is [str]
            default {
                Write-Error "UnhandledTypeNameExeption: '$InputObject'"
            }

        }
        switch ($InputObject) {
            # is [str]
            'Now' {
                [datetime]::Now
            }
            'Today' {
                [datetime]::Today
            }
            { $_ -in 'StopWatch', 'Watch' } {
                Write-Warning '<wip: call my watch func> use my watch, return as started running'
            }
            Default {
                Write-Error "UnhandledTypeNameExeption: '$InputObject'"
                [datetime]::Now
            }
        }

        switch ($PSCmdlet.ParameterSetName) {
            '__AllParameterSets' {
                Write-Debug 'Mode: Now [date]'
                break
            }
            default {
                throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
            }
        }

        # fallback case, current time
        return [Datetime]::Now

        $p = 0

    }
    end {
    }
}

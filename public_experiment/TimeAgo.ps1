#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        # 'Get-WhatObjectType' ?
        'Get-TimeStuff'
        
    )
    $experimentToExport.alias += @(                      
        'seconds',
        'minutes',
        'hours',
        'days',
        'weeks',
        'months',
        'years'
    )
}
# }
    
function Resolve-RelativeTime {
    <#
    .synopsis
        Stuff
    .description
       .
    .example
          .
    .outputs
          [string | None]
    
    #>
    [Alias(
        'Future⌚', 'Past⌚',
        'BeforeNow⌚', 'AfterNow⌚',
        'TimeAsPast',
        'TimeAsFuture'
    )]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [object]$InputObject
    )
    
    begin {
    }
    process {
        Write-Error -Category NotImplemented -m "nyi: '$PSCommandPath'"
        $now = [datetime]::Now
       
    }
    end {
    }
}


function Get-TimeStuff {
    <#
    .SYNOPSIS
    This function makes it easy to get relative dates and timespans.

    .DESCRIPTION
        based on:  Szeraax/Get-TimeStuff.ps1 <https://gist.github.com/Szeraax/43aa193e0759d9b091faaaa2f5a03cc9>
        Get-TimeStuff is a quick way to get "pretty good" relative dates and timespans. It generally is based on "now", but can work on any input time.

    .PARAMETER Moment
    If set, this parameter causes the function to output a specific time. If not, the functio outputs a timespan

    .PARAMETER As
    If the parameter "Moment" is set (which causes the function to output a specific time), this parameter determines what type of object to return

    .PARAMETER Amount
    The number to multiply by

    .PARAMETER Reference
    The beginning [datetime] object to use as a reference

    .EXAMPLE
    Outputs what time it was a day ago
    PS> 1 | day ago

    Thursday, November 4, 2021 10:16:10 PM

    .EXAMPLE
    Outputs what time it will be in 3 years
    PS> 3 | years FromNow

    Tuesday, November 5, 2024 10:16:50 PM

    .EXAMPLE
    Outputs how long 2 months is as a timespan object (relative to $Reference time)
    PS> 2 | months

    Days              : 61
    Hours             : 0
    Minutes           : 0
    Seconds           : 0
    Milliseconds      : 0
    Ticks             : 52704000000000
    TotalDays         : 61
    TotalHours        : 1464
    TotalMinutes      : 87840
    TotalSeconds      : 5270400
    TotalMilliseconds : 5270400000

    .EXAMPLE
    Outputs what moment it was 4 weeks ago as a datetime object
    PS> 4 | weeks ago -as Dto

    DateTime      : 10/8/2021 10:17:15 PM
    UtcDateTime   : 10/9/2021 4:17:15 AM
    LocalDateTime : 10/8/2021 10:17:15 PM
    Date          : 10/8/2021 12:00:00 AM
    Day           : 8
    DayOfWeek     : Friday
    DayOfYear     : 281
    Hour          : 22
    Millisecond   : 954
    Minute        : 17
    Month         : 10
    Offset        : -06:00:00
    Second        : 15
    Ticks         : 637693282359545988
    UtcTicks      : 637693498359545988
    TimeOfDay     : 22:17:15.9545988
    Year          : 2021

    #>
    [Alias(
        'second', 'seconds',
        'minute', 'minutes',
        'hour', 'hours',
        'day', 'days',
        'week', 'weeks',
        'month', 'months',
        'year', 'years'
    )]
    param(
        [ValidateSet('Ago', 'FromNow')]
        $Moment,
        [ValidateSet('dto', 'datetimeoffset', 'datetime', 'dt')]
        $As = 'datetime',
        [parameter(ValueFromPipeline)]
        $Amount,
        $Reference = (Get-Date)
    )
    begin {
        function findMyAlias {
            Get-Alias -Definition 'Get-TimeStuff' | ForEach-Object Name | Sort-Object -Unique
        }
        if ($PSBoundParameters.Moment -in @('Ago')) {
            $direction = -1 
        } else {
            $direction = 1 
        }
    }
    process {
        switch -Wildcard ($MyInvocation.InvocationName) {
            'second*' {
                $instant = $Reference.AddSeconds($Amount * $direction) 
            }
            'minute*' {
                $instant = $Reference.AddMinutes($Amount * $direction) 
            }
            'hour*' {
                $instant = $Reference.AddHours($Amount * $direction) 
            }
            'day*' {
                $instant = $Reference.AddDays($Amount * $direction) 
            }
            'week*' {
                $instant = $Reference.AddDays(7 * $Amount * $direction) 
            }
            'month*' {
                $instant = $Reference.AddMonths($Amount * $direction) 
            }
            'year*' {
                $instant = $Reference.AddYears($Amount * $direction) 
            }
            default {
                throw (findMyAlias | Sort-Object | Join-String -sep ', ' -op 'Use aliases, not the command name!: ')
            }
        }

        if (-not $PSBoundParameters.Moment) {
            if (($timespan = $Reference - $instant) -lt 0) {
                $timespan *= -1 
            }
            $timespan
        } else {
            if ($As -in 'dt', 'datetime') {
                $instant 
            } elseif ($As -in 'dto', 'datetimeoffset') {
                $instant -as [System.DateTimeOffset] 
            }
        }
    }
}


if ( ! $experimentToExport ) {
    RelativeTs 1h
    hr
    1 | months | ForEach-Object tostring
    4 | months ago | ForEach-Object tostring
    hr

    1 | minutes ago 

    RelativeTs 1d | Past⌚
    RelativeTs 1d | Future⌚ 

}

# allows script to be ran alone, or, as module import
if (! $DebugInlineToggle -and $ExperimentToExport) {
    $experimentToExport.function += @(
        'Join-StringStyle'
    )
    $experimentToExport.alias += @(
        #
        #for the main command, i'm not sure if I want
        # 'Join-StringStyle'
        'Join-StyleString'
        # ideas for alias names?


        if ($true) {
            # allow user override/disable for aggressive aliases
            # or maybe an arg to Import-Module for exluding aliases
            'Str', 'JoinStr',
            'Csv', 'NL',
            'Prefix', 'Suffix',
            'QuotedList', #single/double
            'UL', 'Checklist'
        }

        # Like prefix, but "key: Value" pairs
        # 'Pair'
    )

    $DisabledNamesThatWillBeMetadata = @(
        'Cli_Interactive🖐', 'Format🎨', 'Style🎨', 'TextProcessing📚'
    )
    # $MaybeAlias?_DisabledList = @(
    #     'Label' # Same thing? as Prefix?
    #     'Op'
    #     'Op🐒'
    #     'OpStr'
    #     'Pre'
    #     'Prefix'
    #     'QuotedList'
    #     'Suffix'
    #     'UList'

    # )
}


function Join-StringStyle {
    <#
    .synopsis
        Sugar for prefixing line[s] of text
    .description
        this function may turn into an entry point
            customizing defaults based on smart aliases
    .notes
        future:
            - [ ] optional parameter name, so you could use
                ls . *.json | str Prefix 'config: ' -prop 'Name'
            - [ ] optional join on str argument when using ie: prefix ?

            - [ ] after first pass, use dynamically generated join styles for type safety
    .example
        🐒> 0..4 | csv

            0, 1, 2, 3, 4

        🐒> 'cat', (get-date), 'dog' | csv

            cat, 10/18/2021 18:25:24, dog

    .example
        🐒> (get-date).psobject.properties.Name
            | str UL -Sort
            | str Prefix 'Properties of [datetime]'

            Properties of [datetime]
            - Date
            - DateTime
            - Day
            - DayOfWeek
            - DayOfYear
            - DisplayHint
            - Hour
            - Kind
            - Millisecond
            - Minute
            - Month
            - Second
            - Ticks
            - TimeOfDay
            - Year

    .example
        # discover smart aliases:
        🐒> get-alias -Definition Join-StringStyle

            CommandType     Name
            -----------     ----
            Alias           csv -> Join-StringStyle
            Alias           JoinStr -> Join-StringStyle
            Alias           str -> Join-StringStyle
    .example

        🐒> (get-date).psobject.properties.Name
            | csv
            | str Prefix 'Properties of [datetime]: '

            Properties of [datetime]: DisplayHint, DateTime, Date, Day, DayOfWeek, DayOfYear, Hour, Kind, Millisecond, Minute, Month, Second, Ticks, TimeOfDay, Year
    .link
        Dev.Nin\Split-String
    #>
    [alias(
        'Str', 'JoinStr',
        'Csv', 'NL',
        'Prefix', 'Suffix',
        'QuotedList', #single/double
        'UL', 'Checklist'
    )]
    [OutputType([String])]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Input pipeline
        [AllowEmptyCollection()]
        [AllowNull()]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        # [object[]]$InputObject,
        [string[]]$InputObject,

        # if not validateset, use as the actual join?
        [Parameter(Position = 0)] #
        [ArgumentCompletions(
            'Csv', 'NL', 'Prefix', 'QuotedList',
            'UL', 'Checklist'
        )] # todo: map to completions generator
        # [ArgumentCompletions('Csv', 'NL', 'UList', 'QuotedList')]
        [string]$JoinStyle = 'Csv',


        # Optional text, exact placement depends on JoinStyle
        [Parameter(Position = 1)] #
        [string]$Text = $Null,

        # Pre-sort values ?
        [Parameter()] #
        [Switch]$Sort,

        # Unique values when sorting ?
        [Parameter()] #
        [Switch]$Unique,

        # output results to another stream, used by smart alias
        # for quick debug commands
        [Alias('DbgOutput', 'DbgOut')]
        [Parameter()] #
        [Switch]$OutputStreamDebug,

        # DoubleQuotes instead of single quotes, if used in the formatter
        [Parameter()] #
        [Switch]$DoubleQuote



        # future: todo: # property name if not string
        # [Parameter()] #
        # [string]$PropertyName
    )

    begin {
        try {
            $InputLines = [System.Collections.Generic.List[string]]::new()
            [hashtable]$splat_JoinStyle = @{
                # Separator    = ', '
                # OutputPrefix = 'x'
                # OutputSuffix = 'x'
                # Property     = 'x'
                # FormatString = '{0}'
                # DoubleQuote  = $true
                # SingleQuote  = $true
            }
            $myInvokeName = $pscmdlet.MyInvocation.InvocationName

            $myInvokeName
            | Join-String -op 'InvocationName: ' | Write-Debug


            # these are global alias names to the command itself
            $smartAlias = $myInvokeName -eq @(
                'Str', 'JoinStr',
                'Csv', 'NL',
                'Prefix', 'Suffix',
                'QuotedList', #single/double
                'UL', 'Checklist'
                $PSCmdlet.MyInvocation.MyCommand.Name.ToString()

            )
            $SmartAlias | Join-String -op '$SmartAlias: ' | Write-Debug
            $JoinStyle | Join-String -op 'JoinStyle (before alias): ' | Write-Debug
            if (! $SmartAlias) {
                if ($myInvokeName -ne $PSCmdlet.MyInvocation.MyCommand.Name) {
                    Write-Verbose "Alias not implemented: '$myInvokeName'"
                }
                else {
                }
            }

            # map aliases to default configs, many directly map to a style
            # maybe this switch will always be redundant
            switch ($smartAlias) {
                'JoinStr' {
                    # .. normal
                }
                'Csv' {
                    # $Fg = 'orange'
                    $JoinStyle = 'Csv'
                }
                'NL' {
                    $JoinStyle = 'NL'
                }
                # 'Pair' {
                #     $JoinStyle = 'Pair'
                # }
                'Prefix' {
                    $JoinStyle = 'Prefix'
                }
                'Suffix' {
                    $JoinStyle = 'Suffix'
                }
                'QuotedList' {
                    $JoinStyle = 'QuotedList'
                }
                { $false -eq $_ } {
                    # $JoinStyle = 'Csv'
                }
                default {
                    $JoinStyle = 'Csv' # or none or NL ?
                    Write-Warning "Should not reach, unhandled '$SmartAlias' case"
                    Write-Error 'should never reach'
                }
            }

            $JoinStyle | Join-String -op 'JoinStyle (after alias): ' | Write-Debug

            # style based behavior
            switch ($JoinStyle) {
                'Csv' {
                    $splat_JoinStyle.Separator = ', '
                }
                'NL' {
                    $splat_JoinStyle.Separator = "`n"
                }
                # 'Pair' {
                #     $splat_JoinStyle.Separator = ', '
                #     $splat_JoinStyle.OutputPrefix = "${Text}: "
                # }
                'Prefix' {
                    $splat_JoinStyle.OutputPrefix = "${Text}"
                }
                'Suffix' {
                    $splat_JoinStyle.OutputSuffix = "${Text}"
                }
                'QuotedList' {
                    $splat_JoinStyle.Separator = ', ' # or user's -sep

                    if (! $DoubleQuote) {
                        $splat_JoinStyle.SingleQuote = $true
                    }
                    else {
                        $splat_JoinStyle.DoubleQuote = $true
                    }

                }
                'UL' {
                    $splat_JoinStyle.Separator = "`n- "
                    $splat_JoinStyle.OutputPrefix = "`n- "
                }
                'Checklist' {
                    $splat_JoinStyle.Separator = "`n- [ ] "
                    $splat_JoinStyle.OutputPrefix = "`n- [ ] "
                }
                default {
                    $splat_JoinStyle.Separator = ', ' # or user's -sep
                    Write-Warning "Should not reach, unhandled '$SmartAlias' case"
                    Write-Error 'should never reach'
                }
            }

            $splat_JoinStyle | Format-Table | Out-String | Write-Debug

        }
        catch {
            $PSCmdlet.WriteError($_)
        }

    }

    process {
        # try {
        $InputObject | ForEach-Object {
            if ($null -eq $_) {
                $InputLines.Add( '␀' )
            }
            else {
                $InputLines.Add( $_ )
            }
            # need to validate this is equivalent or better: $InputLines.AddRange( $InputObject )
            # todo: stringbuffer, and profile performance.
            # May use internal -join operators for speed
        }

        # }
        # catch {
        #     $PSCmdlet.WriteError($_)
        # }
    }
    end {
        # try {
        $sort_splat = @{}
        if ($Unique) {
            $sort_splat['Unique'] = $True
            $Sort = $true
        }
        if ($sort) {
            $InputLines | Sort-Object @sort_splat | Join-String @splat_JoinStyle
        }
        else {
            $InputLines | Join-String @splat_JoinStyle
        }

        # }
        # catch {
        # $PSCmdlet.WriteError($_)
        # }
    }
}

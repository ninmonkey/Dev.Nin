#Requires -Version 7
# allows script to be ran alone, or, as module import

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Join-StringStyle'
    )
    $experimentToExport.alias += @(
        'str' #  'Join-StringStyle'
    )
}

function Join-StringStyle {
    <#
    .synopsis
        Sugar for prefixing line[s] of text
    .description
        this function may turn into an entry point
            customizing defaults based on smart aliases
    .notes
        failure case:
                🐒> Get-ChildItem . | f 5 | ForEach-Object{
                    $_ | dict 'name', 'Length', 'LastWriteTIme'
                    } | str nl 2
                System.Collections.Specialized.OrderedDictionary

                System.Collections.Specialized.OrderedDictionary

                System.Collections.Specialized.OrderedDictionary

                System.Collections.Specialized.OrderedDictionary

                System.Collections.Specialized.OrderedDictionary

        future:
            - [ ] prefix/suffix on itself
            -


                Join-ScriptblockBySep, something like
                    $error[0..3] | Inspect->ErrorType
                    | Str hr


            - [ ] optional parameter name, so you could use
                ls . *.json | str Prefix 'config: ' -prop 'Name'
            - [ ] optional join on str argument when using ie: prefix ?

            - [ ] after first pass, use dynamically generated join styles for type safety

        Styles:

            csv
                [string]separator = ''
            NL
                [int]numLines = 1
            HR
                [int]extraLinesToPad = 1
            Str
                [string]$JoinOnSeparator
    bug:
        [1]
            # this prints

                ls . -File | New-HashtableFromObject Name
                | Str hr

                System.Collections.Specialized.OrderedDictionary
                ------------------------------------------------
                System.Collections.Specialized.OrderedDictionary

            # fixed by 'out-string' first

                ls . -File | New-HashtableFromObject Name
                | Out-String | Str hr

            # not: but not fixed by ToString()

                ls . -File | New-HashtableFromObject Name
                | % tostring | Str hr

    .example
        # finds history, pretty easy quick summary
        PS> history | ? CommandLine -Match 'formatErr.*options'
            | str hr -Unique CommandLine
    .example
        🐒> 0..3 | str csv
            0,1,2,3

        🐒> 0..3 | str csv -sep ' '
            0, 1, 2, 3


        🐒> 0..3 | str str '> <' | join-string -op '<' -os '>'
            <0> <1> <2> <3>

        🐒> 'cat', (get-date), 'dog' | csv

            cat, 10/18/2021 18:25:24, dog

        🐒> 'c', 'a', 't' | str str "),`n(" | join-string -op '(' -os ')'

            (c),
            (a),
            (t)

        🐒> (get-date).ToShortDateString(), (gi C:\Temp), 'cat', 0x234, (126 | bits)
        | str str ', ' | join-string -op '(' -os ')'

        🐒>  (get-date).ToShortDateString(), (gi C:\Temp), 'cat', 0x234, (126 | bits)
        | str str ', ' -DoubleQuote
        | join-string -op '( ' -os ' )'

            ( "11/17/2021", "C:\Temp", "cat", "564", "0111.1110" )



    .example
        🐒> Get-History  | str hr

            ------------------------------------------
            ul
            ------------------------------------------
            0..4 | Str
            ------------------------------------------
            0..4 | Str UL
            ------------------------------------------
            str csv
            ------------------------------------------
            hr csv
            ------------------------------------------
            0..3 | str csv
            ------------------------------------------
            Import-Module Dev.Nin -Force
            0..4 | str csv
            ------------------------------------------

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
        🐒> "a`nb" | Str UL -SplitNL

        # Instead of:
        PS> "a`nb" | Split-String Newline | Str UL
        PS> "... | %{ $_ -split '\r?\n' } | str UL"

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
    .link
        Utility\Join-Before
    .link
        Utility\Join-After

    #>
    [alias(
        <#
            to add:
                'None' does -join ''

            'Str' does -join $separator

            I'm not currently using func aliases like 'csv'
        #>
        'Str'
        # 'JoinStr',
        # 'Csv', 'NL',
        # 'HR',
        # 'Prefix', 'Suffix',
        # 'Table',
        # 'QuotedList', #single/double
        # 'UL', 'Checklist'
    )]
    [OutputType([String])]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # Input pipeline
        [AllowEmptyCollection()]
        [AllowNull()]
        [AllowEmptyString()]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        # [object[]]$InputObject,
        [object[]]$InputObject,

        # if not validateset, use as the actual join?
        [Parameter(Position = 0)] #
        [ArgumentCompletions(
            'Csv', 'NL', 'Prefix', 'Suffix', 'HR',
            'QuotedList',
            'Bracket',
            'UL', 'Checklist',
            'Table'
        )] # todo: map to completions generator
        # [ArgumentCompletions('Csv', 'NL', 'UList', 'QuotedList')]
        [string]$JoinStyle = 'Csv',


        # Optional text, exact placement depends on JoinStyle
        # [AllowNull()]
        [Parameter(Position = 1)] #
        [string]$Separator, # = $Null,

        # Pre-sort values ?
        [Parameter()] #
        [Switch]$Sort,

        # some sugar for when you need to split to join: "... | %{ $_ -split '\r?\n' } | str UL"
        [Alias('SplitInputsByNewline')]
        [Parameter()] #
        [Switch]$SplitNL,

        # Unique values when sorting ?
        [Parameter()] #
        [Switch]$Unique,

        # output results to another stream, used by smart alias
        # for quick debug commands
        [Alias('DbgOutput', 'DbgOut')]
        [Parameter()] #
        [Switch]$OutputStreamDebug,

        # DoubleQuotes instead of single quotes, if used in the formatter
        [Alias('Quote')]
        [Parameter()] #
        [Switch]$SingleQuote,

        # extra string to the end of pipe
        [ALias('op')]
        [Parameter()][string]$OutputPrefix,

        # extra string prefix
        [ALias('os')]
        [Parameter()][string]$OutputSuffix,

        # DoubleQuotes instead of single quotes, if used in the formatter
        [Parameter()] #
        [Switch]$DoubleQuote,

        # generate the string using a SB
        [ScriptBlock]$ScriptBlockFormat

        # # By Property name, else param: Foreground [rgbcolor]
        # [Alias('Fg', 'Color', 'ForegroundColor')]
        # [ValidateNotNullOrEmpty()]
        # [Parameter(ValueFromPipelineByPropertyName)]
        # [PoshCode.Pansies.RgbColor]
        # $ForegroundColor,

        # # By Property name, else param: Foreground [rgbcolor]
        # [Alias('Bg', 'BackgroundColor')]
        # [ValidateNotNullOrEmpty()]
        # [Parameter(ValueFromPipelineByPropertyName)]
        # [PoshCode.Pansies.RgbColor]
        # $BackgroundColor



        # future: todo: # property name if not string
        # [Parameter()] #
        # [string]$PropertyName
    )

    begin {
        # try {
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
        $isSmartAlias = $myInvokeName -in @(
            'Str', 'JoinStr',
            'Csv', 'NL',
            'Prefix', 'Suffix',
            'QuotedList', #single/double
            'UL', 'Checklist',
            'Table'
            $PSCmdlet.MyInvocation.MyCommand.Name.ToString()

        )
        @{
            InvocationName = $myInvokeName
            IsSmartAlias   = $isSmartAlias
            SmartAlias     = $smartAlias ?? ''
        } | Format-Table | Out-String | Write-Debug

        # $SmartAlias | Join-String -op '$SmartAlias: ' | Write-Debug
        # $JoinStyle | Join-String -op 'JoinStyle (before alias): ' | Write-Debug
        # if (! $SmartAlias) {
        #     if ($myInvokeName -ne $PSCmdlet.MyInvocation.MyCommand.Name) {
        #         Write-Verbose "Alias not implemented: '$myInvokeName'"
        #     } else {
        #     }
        # }


        # map aliases to default configs
        if ($isSmartAlias) {
            switch ($JoinStyle) {
                # todo: Make JoinStyle a concrete type, and use it for the parameterset
                'JoinStr' {
                    # .. normal
                    break
                }
                'Csv' {
                    # $Fg = 'orange'
                    $JoinStyle = 'Csv'
                    break
                }
                'NL' {
                    $JoinStyle = 'NL'
                    break
                }
                'HR' {
                    $JoinStyle = 'HR'
                    break
                }
                # 'Pair' {
                #     $JoinStyle = 'Pair'
                #   break
                # }
                'Prefix' {
                    $JoinStyle = 'Prefix'
                    break
                }
                'Table' {
                    $JoinStyle = 'Table'
                    break
                }
                'Suffix' {
                    $JoinStyle = 'Suffix'
                    break
                }
                'Bracket' {
                    $JoinStyle = 'Bracket'
                    break
                }
                'QuotedList' {
                    $JoinStyle = 'QuotedList'
                    break
                }
                { $false -eq $_ } {
                    # $JoinStyle = 'Csv'
                    break
                }
                default {
                    # $JoinStyle = 'Csv'
                    break

                    @(
                        'fallback to default case for:'
                        @{
                            isSmartAlias = $isSmartAlias
                            SmartAlias   = $smartAlias
                            JoinStyle    = $JoinStyle
                        } | Format-Table
                    ) | Out-String | Write-Warning # revert to -debug after a while
                    # write-ninlog
                    # $JoinStyle = 'Csv' # or none or NL ?
                    # Write-Warning "Should not reach, unhandled '$SmartAlias' case"
                    # Write-Error 'should never reach'
                }
            }
        }

        $JoinStyle | Join-String -op 'JoinStyle (after alias): ' | Write-Debug
        if ($DoubleQuote) {
            $splat_JoinStyle['DoubleQuote'] = $true
            $splat_JoinStyle.Remove('SingleQuote')
        }
        if ($SingleQuote) {
            $splat_JoinStyle['SingleQuote'] = $true
            $splat_JoinStyle.Remove('DoubleQuote')
        }

        # style based behavior
        switch ($JoinStyle) {
            'Str' {
                $splat_JoinStyle.Separator = $Separator
            }
            'Csv' {
                $Separator ??= ' '
                $joinStr = ',{0}' -f @($Separator)
                $splat_JoinStyle.Separator = $joinStr # was: ', '

            }
            'NL' {
                if ( [string]::IsNullOrEmpty($Separator) ) {
                    $lineCount = 1
                } else {
                    $lineCount = $separator -as [int]
                    $lineCount ??= 1
                }
                # $lineCount ??= 2
                $splat_JoinStyle.Separator = ("`n" * $lineCount) -join ''
            }
            'HR' {
                if ( [string]::IsNullOrWhiteSpace( $Separator) ) {
                    $extraLines = 1
                } else {
                    $extraLines = $separator -as [int]
                    $extraLines ??= 1
                }
                $splat_JoinStyle.Separator = hr -ExtraLines $extraLines | ForEach-Object tostring

            }
            # 'Pair' {
            #     $splat_JoinStyle.Separator = ', '
            #     $splat_JoinStyle.OutputPrefix = "${Text}: "
            # }
            'Prefix' {
                # note: currently 2nd operand is named separator but it's for others
                $splat_JoinStyle.OutputPrefix = "${Separator}${Text}"
            }
            'Suffix' {
                $splat_JoinStyle.OutputSuffix = "${Text}${Separator}"
            }
            'QuotedList' {
                $splat_JoinStyle.Separator = ', ' # or user's -sep

                if (! $DoubleQuote) {
                    $splat_JoinStyle.SingleQuote = $true
                } else {

                }

            }
            'Table' {
                # markdown
                $splat_JoinStyle.Separator = ' | '
                $splat_JoinStyle.OutputPrefix = '| '
                $splat_JoinStyle.OutputSuffix = ' |'
            }
            'Bracket' {
                $splat_JoinStyle.Separator = ''
                $splat_JoinStyle.OutputPrefix = '['
                $splat_JoinStyle.OutputSuffix = ']'

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
                $splat_JoinStyle.Separator = ' ' # or user's -sep
                Write-Debug "${PSCommandPath} using generic case on with  not reach, unhandled '$SmartAlias' case"
                # Write-Error 'should never reach'
            }
        }
        if ($splat_JoinStyle.DoubleQuote) {
            $splat_JoinStyle.SingleQuote = $false
        }

        $splat_JoinStyle | Format-Table
        | Out-String
        # warning: infintie loop if I had use: # | str prefix '-Begin { .. }s final value "$splat_JoinStyle"'
        | Write-Debug

        # }
        # catch {
        #     $PSCmdlet.WriteError($_)
        # }

    }

    process {
        # try {
        if ($SplitNL) {
            $InputObject = $InputObject -split '\r?\n'
        }
        $InputObject | ForEach-Object {
            if ($null -eq $_) {
                $InputLines.Add( '␀' )
            } else {
                if (! $ScriptBlockFormat) {
                    # if using [list[string]],  if it's a non-object, error because
                    # there's no PSCO to string coercion path
                    # I am not sure whether it will be useful, in the future,
                    # to preserve this as an object for some functionality
                    # or maybe stepped pipeline would have more flexibility
                    # with obj verses str
                    # wait,
                    $InputLines.Add( [string]$_ )
                } else {
                    # future: cleaner join on SB
                    $render = & $ScriptBlock $InputLines
                    $InputLines.Add( $Render )
                }
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
        # single/double are exlusive
        if ($DoubleQuote) {
            $splat_JoinStyle['DoubleQuote'] = $true
            $splat_JoinStyle.Remove('SingleQuote')
        }
        if ($SingleQuote) {
            $splat_JoinStyle['SingleQuote'] = $true
            $splat_JoinStyle.Remove('DoubleQuote')
        }

        $sort_splat = @{}
        if ($Unique) {
            $sort_splat['Unique'] = $True
            $Sort = $true

        }

        # $x = ($InputLines | Join-String @splat_JoinStyle) | Write-Host
        # $x.GetType().FullName | Write-Host

        $finalRender = if ($sort) {
            $InputLines | Sort-Object @sort_splat
            | Join-String @splat_JoinStyle
        } else {
            $InputLines | Join-String @splat_JoinStyle
        }


        # Maybe this is causing the unwanted list wrapped value
        if ($true) {
            $finalRender | Join-String -op $OutputPrefix -os $OutputSuffix -sep ''
        } else {
            # Maybe this is causing the unwanted list wrapped value
            Write-Output -NoEnumerate (
                $finalRender | Join-String -op $OutputPrefix -os $OutputSuffix -sep ''
            )
            # Do not remember why it was used/required
        }


        # }
        # catch {
        # $PSCmdlet.WriteError($_)
        # }
    }
}

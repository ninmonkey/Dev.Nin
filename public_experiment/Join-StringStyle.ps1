
# allows script to be ran alone, or, as module import
if (! $DebugInlineToggle ) {
    $experimentToExport.function += @(
        'Dev.Join-StringStyle'
    )
    $experimentToExport.alias += @(
        # ideas for alias names?
        'Csv', 'NL', 'Prefix', 'QuotedList', 'Pair' # Like prefix, but "key: Value" pairs
    )
    $MaybeAlias?_DisabledList = @(
        'Label' # Same thing? as Prefix?
        'NL'
        'Op'
        'Op🐒'
        'OpStr'

        'Pre'
        'Prefix'
        'QuotedList'
        'Suffix'
        'UList'

    )
}


function Dev.Join-StringStyle {
    <#
    .synopsis
        Sugar for prefixing line[s] of text
    .description
        this function may turn into an entry point
            customizing defaults based on smart aliases
    .notes
        future
            - [ ] after first pass, use dynamically generated join styles for type safety
    .
    #>
    [alias()]
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
        [Parameter(Mandatory, Position = 0)] #
        [ArgumentCompletions('Csv', 'NL', 'Prefix', 'QuotedList', 'Pair')] # todo: map to completions generator
        # [ArgumentCompletions('Csv', 'NL', 'UList', 'QuotedList')]
        [string[]]$JoinStyle = 'Csv',


        # Optional text, exact placement depends on JoinStyle
        [Parameter(Position = 1)] #
        [string]$Text = $Null,

        # Pre-sort values ?
        [Parameter()] #
        [Switch]$Sort,

        # Unique values when sorting ?
        [Parameter()] #
        [Switch]$Unique



        # future: todo: # property name if not string
        # [Parameter()] #
        # [string]$PropertyName
    )

    begin {
        try {
            $InputLines = [list[string]]::new()
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

            $smartAlias = $myInvokeName -eq @(
                'Csv', 'NL', 'Prefix', 'QuotedList', 'Pair', $PSCmdlet.MyInvocation.MyCommand.Name.ToString()

            )
            $SmartAlias | Join-String -op '$SmartAlias: ' | Write-Debug
            $JoinStyle | Join-String -op 'JoinStyle (before alias): ' | Write-Debug
            if (! $SmartAlias) {
                if ($myInvokeName -ne $PSCmdlet.MyInvocation.MyCommand.Name) {
                    Write-Warning "Alias not implemented: '$myInvokeName'"
                }
                else {
                }
            }

            # map aliases to default configs, many directly map to a style
            # maybe this switch will always be redundant
            switch ($smartAlias) {
                'Csv' {
                    # $Fg = 'orange'
                    $JoinStyle = 'Csv'
                }
                'NL' {
                    $JoinStyle = 'NL'
                }
                'Pair' {
                    $JoinStyle = 'Pair'
                }
                'Prefix' {
                    $JoinStyle = 'Prefix'
                }
                'QuotedList' {
                    $JoinStyle = 'QuotedList'
                }
                { $false -eq $_ } {
                    # $JoinStyle = 'Csv'
                }
                default {
                    $JoinStyle = 'Csv' # or none or NL ?
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
                'Pair' {
                    $splat_JoinStyle.Separator = ', '
                    $splat_JoinStyle.OutputPrefix = "${Text}: "
                }
                'Prefix' {
                    $splat_JoinStyle.OutputPrefix = "${Text} "
                }
                'QuotedList' {
                    $splat_JoinStyle.Separator = ', '
                    $splat_JoinStyle.SingleQuote = $true

                }
                default {
                    $splat_JoinStyle.Separator = ', '
                }
            }

            $splat_JoinStyle | Format-Table | Out-String | Write-Debug

        }
        catch {
            $PSCmdlet.WriteError($_)
        }

    }

    process {
        try {
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

        }
        catch {
            $PSCmdlet.WriteError($_)
        }
    }
    end {
        try {
            $sort_splat = @{}
            if ($Unique) {
                $sort_splat['Unique'] = $True
            }
            if ($sort) {
                $InputLines | Sort-Object @sort_splat | Join-String @splat_JoinStyle
            }
            else {
                if ($Unique) {
                    Write-Warning '-Unique /w -Sort:$False does nothing.'
                }
                $InputLines | Join-String @splat_JoinStyle
            }

        }
        catch {
            $PSCmdlet.WriteError($_)
        }
    }
}

if ($DebugInlineToggle ) {

    # 0..5 | Dev.Join-StringStyle CSv
}

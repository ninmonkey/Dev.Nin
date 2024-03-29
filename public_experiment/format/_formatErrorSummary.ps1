#Requires -Version 7
using namespace System.Collections.Generic
using namespace System.Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        '_formatErrorSummarySingleLine'
        '_processErrorRecord'
        'Inspect-ErrorType'

        #  testing
        'showErr'
        'formatErr'


        'ConvertTo-HashToArgumentCompletionLiteral'
    )
    $experimentToExport.alias += @(
        'Inspect->ErrorType'
        # ''
        'to->ArgumentCompletionsLiteral' # 'ConvertTo-HashToArgumentCompletionLiteral'
    )
}

function ConvertTo-HashToArgumentCompletionLiteral {
    <#
    .synopsis
        for raw inline literals
    .notes
        future: added command:
            .. | str HereString

    #>
    [Alias('to->ArgumentCompletionsLiteral')]
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0)]
        [Alias('InputObject')]
        [string]$CodeSnippet,
        [switch]$SkipFormatting
    )

    $accum = $CodeSnippet -replace '(\r?\n)', "`n" -replace "'", "''"
    if (! $SkipFormatting) {
        # $accum = $accum | Invoke-NinFormatter -wa ignore
    }
    $accum | Join-String -SingleQuote

    #     $rawIn = @'
    # @{ColorErrorRed = [rgbcolor]'seaGreen2'; ColorFg = [rgbcolor]'darkseagreen4'}
    # '@ -replace "'", '"' -replace ';', "`n" | Invoke-NinFormatter
}

$convertToHashToArgumentCompletionLiteralSplat = @{
    CodeSnippet = (
        '@{ColorErrorRed = [rgbcolor]"seaGreen2" ColorFg = [rgbcolor]"darkseagreen4" }'
    )
}

ConvertTo-HashToArgumentCompletionLiteral @convertToHashToArgumentCompletionLiteralSplat


function showErr {
    <#
    .synopsis
        view and hide errors easier in the term
    .notes
        'ShowError() => formatErr()'

        todo first:
            - [ ] add numbers, so a full list will match $error[index]

    .example
        🐒> showErr -Max 3

    .example
        🐒> showErr -Recent
            ErrorRecord -> DriveNotFoundException
            Cannot find drive. A drive with the name '
            C' does not exist.
            ------------------------------------------------------------------------
            ErrorRecord -> SessionStateException

        🐒> err? -PassThru

            LastCount CurCount DeltaCount
            --------- -------- ----------
                27       27          2

        errΔ [2] of [27]
        🐒> err? -Reset


        🐒> showErr -Recent
        # shows 0, does not call clear on errors if -reset
    #>
    # [Alias('showErr')] # convert to alias
    [cmdletbinding()]
    param(
        # err obj
        [Parameter(Position = 0, ValueFromPipeline)]
        [object]$ErrorObject,

        # show recent only
        # future arg: recent meaning time as well, not just counts
        [Alias('ShowRecent')]
        [Parameter()][switch]$Recent,

        # max results limit
        [Alias('Limit')]
        [Parameter()]
        [int]$MaxLimit = 3
    )
    begin {
        [list[object]]$errorList = [list[object]]::new()
    }
    process {
        # clean-todo: replace with resolve->ErrorInfo
        # scope:global (or +1) is sometimes required when using debuggers with dev tools
        # was:  $Target = $ErrorObject ?? $global:Error # sometimes required when using debuggers
        $Target = $ErrorObject ?? $error ?? $global:Error
        $errorList.Add( $Target )
        # $errorList.AddRange( $Target )
        <#
            line:
                $errorList.AddRange( $Target )
            vs
                $errorList.Add( $Target )
            throws
                Cannot convert the "System.Collections.ArrayList" value of
                type "System.Collections.ArrayList" to type
                "System.Collections.Generic.IEnumerable`1[System.Object]"
        #>
    }
    end {
        $deltaCount = (err? -PassThru).deltaCount

        <#
        I think this originally had write-warning, to get past being consumed.
        #>
        $meta = [Ordered]@{
            Recent     = $Recent
            DeltaCount = $deltaCount
            MaxLimit   = $MaxLimit
        }

        if ($Recent) {
            $MaxLimit = $deltaCount
            $meta['MaxLimit_AfterRecent'] = $MaxLimit
        }

        if ($MaxLimit) {
            # Write-Warning 'max'
            $results = $errorList | Select-Object -First $MaxLimit
            | ReverseIt
        } else {
            # Write-Warning 'not'
            $results = $errorList
            | ReverseIt
        }
        $meta['ResultCount'] = $results.count
        $results
        | Dev.Nin\formatErr
        | Dev.Nin\str hr

        $splat_FormatSortOrder = @{
            Label   = 'Newest'
            Order   = 'Desc'
            Options = @{FormatMode = 'HighlightName' }
        }

        _write-FormatSortOrder @splat_FormatSortOrder
        $meta | Format-Table -AutoSize | Out-String | Write-Debug
    }

    <#
        try:
        Import-Module Dev.Nin -Force

        $Error | % tostring
        | %{ $_ -replace (ReLit 'System.Management.Automation'), 'sma' }
        |  ShortenStringJoin

#>
}
function Inspect-ErrorType {
    <#
    .synopsis
        internal inspection that generates
    .notes
        'ShowError() => formatErr()'
        'formatErr() => Inspect-ErrorType()'

        - [ ] compare with MapFuncDump and FormatDumps to compare or merge
    #>
    [Alias('Inspect->ErrorType')]
    [CmdletBinding()]
    param(
        # error
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$ErrorObject
    )
    process {
        $NullStr = "[`u{2400}]"
        $hasChildException = $null -ne $ErrorObject.Exception
        $hasChildErrorsList = $null -ne $ErrorObject.Errors

        [hashtable]$dbgInfo = [ordered]@{
            HasChildException      = $hasChildException
            HasChildErrorsListList = $hasChildErrorsList
            String                 = $ErrorObject.ToString()
            Type                   = ($ErrorObject)?.GetType().Name
        }

        if ($hasChildException) {
            $dbgInfo = $dbgInfo + [ordered]@{
                Child_ExceptionString = ($ErrorObject)?.Exception.ToString()
                Child_ExceptionType   = ($ErrorObject)?.Exception.GetType().Name
            }
        } else {
            $dbgInfo = $dbgInfo + [ordered]@{
                Child_ExceptionString = $nullStr
                Child_ExceptionType   = $NullStr
            }
        }
        $dbgInfo
        # -AsObject
        # [pscustomobject]$dbgInfo

        <#
        wanted template:
            [type] -> [childtype] -> [string]

        from:
            #Import-Module Dev.Nin -Force
            $Error | Get-Random -Count 3
            | Inspect-ErrorType
            #| Sort-Hashtable -SortBy  Key
            | Format-Dict
            | out-string
            | SplitStr -SplitStyle Newline
            #|  str hr

        #>
    }
}
function formatErr {
    <#
    .example
            $error | formatErr | str hr 1
    .notes
        'ShowError() => formatErr()'
        'formatErr() => Inspect-ErrorType()'
    #>
    param(
        # err  obj
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$ErrorObject,

        # as raw
        [Parameter()][switch]$AsRaw,

        # options
        [Parameter()]
        [ArgumentCompletions('@{ColorErrorRed = [rgbcolor]"gray35"}')]
        [hashtable]$Options = @{}
    )
    begin {
        # $Colors = @{
        #     ErrorRed   = [PoshCode.Pansies.RgbColor]'PaleVioletRed4'
        #     FgTypeName = 'gray60'
        # }
        # $Colors = Join-Hashtable $Colors ($Options ?? @{})
        # $Config = $Options
        $Config = @{
            ColorErrorRed = [PoshCode.Pansies.RgbColor]'#ee799f'
            ColorFg       = 'gray60'
        }
        $Config = Join-Hashtable $Config $Options

        $Colors = @{
            ErrorRed   = $Config.ColorErrorRed
            FgTypeName = $Config.ColorFg
        }
        $Colors = Join-Hashtable $Colors ($Options ?? @{})
    }
    process {
        if ($null -eq $ErrorObject) {
            return
        }

        if ($AsRaw) {
            $ErrorObject | ShortenString
            return
        }

        $eInfo = $ErrorObject | Inspect-ErrorType
        $einfo | Format-Table | Out-String | Write-Debug

        $prefixTypes = @(
            $eInfo.Type | Write-Color $Colors.FgTypeName
            if ($eInfo.HasChildException) {
                @(
                    ' -> ' | Write-Color $Colors.FgTypeName
                    $eInfo.Child_ExceptionType | Write-Color $Colors.FgTypeName
                ) | Join-String
            }
        ) | Join-String

        $finalRender = @(
            $prefixTypes
            # ': '
            "`n"
            $eInfo.String | Write-Color $Colors.ErrorRed
        ) | Join-String

        $finalRender | ShortenString -MaxLength 200
    }
}
function _formatErrorSummarySingleLine {
    <#
    .synopsis
        formats Summarize errors, one per line
    .notes
        .Format outputs text, see _processErrorRecord for inspection

        'ShowError() => formatErr()'
        None => _formatErrorSummarySingleLine

        _formatErrorSummarySingleLine =>
            (intern) __outputFormat_Minimal
            (intern) __outputFormat_SingleLine

    .example
        PS> _formatErrorSummarySingleLine
    .example
        PS> $error[0..2] | _formatErrorSummarySingleLine
    .inputs
        [Exception] | [RuntimeException] | [ActionPreferenceStopException]
    .outputs
        [string]
    #>
    param(
        #
        [alias(
            # 'Error' # 'default resolves as get-error'
        )]
        [Parameter(ValueFromPipeline, Position = 0)]
        [object]$InputObject,

        # alter style
        [Parameter()]
        [validateset('2Line', 'Single', 'Minimal')]
        [string]$OutputFormat = 'Minimal',

        # MaxWidth / columns
        [Alias('Width')]
        [Parameter()]
        [uint]$MaxLineLength,


        # extra options
        [Parameter()][hashtable]$Options
    )

    begin {
        $errorList = [List[object]]::new()

        [hashtable]$Config = @{
            AlignKeyValuePairs = $true
            Title              = 'Default'
            DisplayTypeName    = $true
            JoinOnString       = hr 1
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})

        [hashtable]$colors = @{
            ErrorDim    = [PoshCode.Pansies.RgbColor]'#8B0000' # darkred'
            ErrorBright = [PoshCode.Pansies.RgbColor]'#FF82AB'
            ErrorPale   = [PoshCode.Pansies.RgbColor]'#CD5C5C'
            Error       = [PoshCode.Pansies.RgbColor]'#CD3700'
            FgVeryDim   = [PoshCode.Pansies.RgbColor]'gray40'
            FgDim       = [PoshCode.Pansies.RgbColor]'gray60'
            Fg          = [PoshCode.Pansies.RgbColor]'gray80'
            FgBright    = [PoshCode.Pansies.RgbColor]'gray90'
            FgBright2   = [PoshCode.Pansies.RgbColor]'gray100'
        }
        $colors = Join-Hashtable $colors ($Options.Colors ?? @{})

    }
    process {

        # if (!$InputObject) {
        #     $InputObject = $global:error # Do I want global or script?
        # }

        if ($InputObject) {
            $errorList.Add( $InputObject )
        }
        # $errorList.Add( $InputObject )

    }
    end {

        function __outputFormat_Minimal {
            [CmdletBinding()]
            param(
                # any error types
                [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
                [object]$InputObject,

                # extra options
                [Parameter()][hashtable]$Config
            )
            begin {
            }
            process {

                $InputObject | ShortenString -MaxLength 0
                # if ($errorList.count -le 0) {
                #     # $errorList.AddRange( $global:error ) # Do I want global or script?
                #     $global:error | ForEach-Object { $errorList.Add( $_ ) }
                # }
                # $MaxLineLength ??= [console]::WindowWidth - 1
                # $errorList | ForEach-Object -Begin { $i = 0 } {
                #     'e -> {0}' -f $i
                #     $_ | ShortenStringJoin -MaxLength $MaxLineLength
                #     $i++
                # } | Join-String -sep (Hr 1)
            }
            end {


            }
            # minimal space taken

        }
        function __outputFormat_2Line {
            # minimal space taken
            $MaxLineLength ??= [console]::WindowWidth - 1

            if ($errorList.count -le 0) {
                # $errorList.AddRange( $global:error ) # Do I want global or script?
                $global:error | ForEach-Object { $errorList.Add( $_ ) }
            }
            $errorList | ForEach-Object -Begin { $i = 0 } {
                'e -> {0}' -f $i
                $_ | ShortenStringJoin -MaxLength $MaxLineLength
                $i++
            } | Join-String -sep (Hr 1)
        }
        function __outputFormat_SingleLine {
            <#
            .synopsis
                warning: actually outputs entire, instead of one record should refactor
            .outputs
                [string] or [string[]]
            .notes
                the error [Automation.ParseException]
                    has these members
                        - [Language.ParseError[]]: Errors
                        - [ErrorRecord]: ErrorRecord

                type: [Automation.ParseException]
                    members:
                        - [Language.ParseError[]]: Errors
                        - [ErrorRecord]: ErrorRecord

                type: [Automation.ErrorRecord]
                    members:
                        - [Automation.ErrorRecord]: ErrorDetails


            #>
            param(
                # extra options
                [Parameter()][hashtable]$Config
            )
            # process {
            $Colors = $Config['Colors']
            $cDef = $colors.Fg
            $cBright = $colors.FgBright
            $cStatus = [rgbcolor]'red'
            $MaxLineLength ??= [console]::WindowWidth - 1

            Write-Warning 'before refactor -> indivisual render function'
            if ($errorList.count -le 0) {
                # $errorList.AddRange( $global:error ) # Do I want global or script?
                $global:error | ForEach-Object { $errorList.Add( $_ ) }
            }
            $FormattedText =
            $errorList | ForEach-Object -Begin { $i = 0 } {
                $curError = $_
                $hasSubErrors = ($null -ne $curError.Errors) -or ($curError.errors.count -gt 0)
                if ($hasSubErrors) {
                    # $errorList.Errors
                    # | ShortenStringJoin
                    # | SplitStr -SplitStyle Newline
                    # | Format-IndentText -Depth 2
                    # | ShortenString

                    # or
                    $errorList.Errors
                    | ShortenStringJoin -MaxLength 90
                    | Format-IndentText -Depth 2
                }
                @(
                    if ($hasSubErrors) {
                        "+ subs`n" | Write-Color $cBright
                    }
                    'errΔ [' | Write-Color $cDef
                    '{0}' -f @(
                        $i | Write-Color $cStatus
                    )
                    ']' | Write-Color $cDef
                    ' of ['
                    '{0}' -f @(
                        $errorList.count | Write-Color $cStatus
                    )
                    ']'

                ) | Join-String

                @(
                    'e[{0}]' -f $i
                    $curError | ShortenStringJoin -MaxLength $MaxLineLength | Write-Color 'gray80'
                ) | Join-String
                | ShortenStringJoin -MaxLength $MaxLineLength # because header changes len

                $i++
            }



            # -------
            $Config.JoinOnString = Hr 1


            switch ($OutputFormat) {
                'Minimal' {
                    $render = __outputFormat_SingleLine -Options $Config
                    $render
                    break
                }
                '2Line' {
                    $render = $ErrorList | __outputFormat_Minimal -Options $Config
                    break
                }
                'Single' {
                    $render = __outputFormat_SingleLine -Options $Config
                }
                default {
                    $render = __outputFormat_SingleLine -Options $Config
                    break
                }
            }

            if ($Config.JoinOnString) {
                $render | Join-String -sep $Config.JoinOnString
            } else {
                $render
            }



            # }
            # end {

            # }

        }


    }
}


# Get-ChildItem


function _processErrorRecord {
    <#
    .synopsis
        attempt to summarize ErrorRecords, and exceptions (maybe split into two)
    .notes
        .
    .example
        PS> _processErrorRecord
    .example
        PS> $error[0..2] | _processErrorRecord
    .inputs
        [Exception] | [RuntimeException] | [ActionPreferenceStopException]
    .outputs
        [PSCustomObject]
    #>
    param(
        #
        [alias(
            'Error',
            'Format->Error'
        )]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object]$InputObject
    )

    begin {
        $Meta = @{}
        $Str = @{
            JoinNewline = ' ◁ ' | New-Text -fg 'gray60' | ForEach-Object tostring            # '… …◁'
        }
        function _inner_processException {
            <#
            .synopsis
                convert Exception to [dev.nin.ExceptionSummary]
            #>
            param(
                # errorRecord instance
                [Parameter(Mandatory, Position = 0)]
                [object]$Exception
            )

            $cur = $Exception

            $tinfo = $cur.GetType()
            $meta = @{
                PSTypeName         = 'dev.nin.ExceptionSummary'
                # TypeName   = $cur.GetType().FullName | New-TypeInfo | Format-TypeName -Brackets
                TypeNameStr        = $tinfo | Format-TypeName -Brackets
                BaseTypeNameStr    = $tinfo.BaseType | Format-TypeName -brack
                ToStr              = $cur | ShortenStringJoin -MaxLength 220 -CollapseWhiteSpace # this shoudl be formatter's logic
                Errors_ErrorId     = $cur.Errors.ErrorId
                Errors_Extent      = $cur.Errors.Extent
                Errors_Message     = $cur.Errors.Message
                'Errors[]_ErrorId' = $cur.Errors.ErrorId
                'Errors[]_Extent'  = $cur.Errors.Extent
                'Errors[]_Message' = $cur.Errors.Message

            }
            [pscustomobject]$meta
        }
        function _processErrorRecord {
            <#
            .synopsis
                convert ErrorRecord to [dev.nin.ErrorRecordSummary]
            #>
            param(
                # errorRecord instance
                [Parameter(Mandatory, Position = 0)]
                [object]$ErrorRecord
            )
            $cur = $ErrorRecord
            # Write-Warning 'left off here'
            $meta = @{
                PSTypeName = 'dev.nin.ErrorRecordSummary'


            }
            [pscustomobject]$meta

        }
    }
    process {

        if ($InputObject -is 'Exception') {
            _inner_processException $InputObject
        } elseif ($InputObject -is [Management.Automation.ErrorRecord]) {
            _processErrorRecord $InputObject
        } else {
            Write-Error -ea stop 'Input is not an Exception?' -Category InvalidType -ErrorId 'NotAnExceptionType' -TargetObject ($InputObject.GetType())
        }

        # if (!($InputObject -is 'Exception')) {

        $meta.Name = $_.GetType() | Format-TypeName -bra # future: logic in FormatData


        # Ensure it's a single line
        # $Meta.String = $_.ToString() -split '\r?\n' | Join-String -sep $str.JoinNewline | ShortenString -MaxLength 120
        $Meta.String = $_ | ShortenString | Join-String -sep $str.JoinNewline | ShortenString -MaxLength 120

        # refactor func

        $Meta.HasChildRecord = $false

        [pscustomobject]$meta

    }
    end {
        Write-Warning "finish me: $PSCommandPath"
    }
}


if (! $experimentToExport) {
    $TestConfig = @{
        Slow_PrintAllExamples = $false
        CompareSingleDefaults = $true

    }
    $TestConfig | Format-dict
    # colors generated by:
    # PS> (find-color red | % rgb | hex | str csv -SingleQuote) -replace '0x', '#'
    $colorList = @(
        '#8b0000', '#cd5c5c', '#ff6a6a', '#ee6363', '#cd5555', '#8b3a3a', '#c71585',
        '#ff4500', '#ff4500', '#ee4000', '#cd3700', '#8b2500', '#db7093', '#ff82ab',
        '#ee799f', '#cd6889', '#8b475d', '#ff0000', '#ff0000', '#ee0000', '#cd0000',
        '#8b0000', '#d02090', '#ff3e96', '#ee3a8c', '#cd3278', '#8b2252'
    )
    # $randErrors = $error | Get-Random -Count 10
    # hard to reproduce in pester context. so inline for now.
    $randErrors = $global:Error | Get-Random -Count 10
    $someErrors = $global:Error | Select-Object -First 5

    if ($TestConfig.Slow_PrintAllExamples) {
        foreach ($c in ($colorList)) {
            h1 "$c | FormatErr -ColorErrorRed" -bef 0 -aft 0
            $randErrors | formatErr -Options @{
                'ColorErrorRed' = $c
            }
        }
    }
    hr
    h1 $colorList[8] -Before 0 -after 0
    $randErrors | formatErr -Options @{'ColorErrorRed' = $colorList[8] }
    h1 $colorList[1] -Before 0 -after 0
    $randErrors | formatErr -Options @{'ColorErrorRed' = $colorList[1] }

    hr 4

    # saved test
    $targetErr = ($savedErr ?? $error[0])
    if ($TestConfig.CompareSingleDefaults) {
        hr -ForegroundColor 'magenta'
        h1 ' | formatErr'
        $targetErr | formatErr
        hr
        h1 ' | _formatErrorSummarySingleLine'
        $targetErr | _formatErrorSummarySingleLine -OutputFormat Single


        h1 'testing for defaults'
        $targetErr | formatErr -Options @{

            'ColorErrorRed' = '#ff4500' # or '#ee799f'
        }
    }

}

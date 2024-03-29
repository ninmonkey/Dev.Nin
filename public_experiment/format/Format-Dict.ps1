# if ($BadDebugEnabled) {

$experimentToExport.function += @(
    'Format-Dict'

    # export private funcs
    # or better, enumerate: $__RegisteredFormatDictExtension
    '_FormatDictItem_ColorList'
    '_FormatDictItem_ColorSingle'
    '_FormatDictItem_Filepath'
    # '_FormatDictItem_Filepath'
    '_FormatDictItem_Boolean'
    '_FormatDictItem_TrueNull'
    # '_FormatDictItem_ShortTypeName'
    # '_FormatDictItem_ControlChar' # or
    '_FormatDictItem_BlankText'
    '_FormatDictItem_EmptyCollection'

)
$experimentToExport.alias += @(
    'fDict'
    # 'Dev.Format-Dict'
    # 'Ansi.Format-Dict'
    # 'New-Sketch'
)
# }

Write-Warning "🚀importing $PSCommandPath"
# submodule constants
$script:__fdItemStr = @{
    'trueNull'      = '[true $null]' | Write-Color gray40
    'null'          = '[␀]' | Write-Color gray60
    'trueEmptyStr'  = '[String]::Empty' | Write-Color gray60
    'blankStr'      = '[Blank String]' | Write-Color gray60
    'whitespaceStr' = '[whitespace]' | Write-Color gray60


    'emptyList'     = '[empty List[]]' | Write-Color gray60
    'emptyHash'     = '[empty Dict{}]' | Write-Color gray60
    # 'emptyStr'     = '[␀]' | write-color gray60
}

function _FormatDictItem_Filepath {
    <#
    .synopsis
        Format-Dict Extension: RelativeFilepaths
    .example
    #>
    param([string]$Path)
    process {
        if (Test-Path $Path) {
            ConvertTo-RelativePath -InputObject $Path
        } else {
            $Path
        }
    }
    # 'try me'
}
function _FormatDictItem_ColorList {
    <#
    .synopsis
        Format-Dict Extension: [rgbcolor[]]
    .notes
        when:
            $x -is [System.Collections.IEnumerable]
            $x[0] -is [PoshCode.Pansies.RgbColor]

    #>
    param([string]$Path)
    process {
        if (Test-Path $Path) {
            ConvertTo-RelativePath -InputObject $Path
        } else {
            $Path
        }
    }
}

function _FormatDictItem_Boolean {
    <#
    .synopsis
        Format-Dict Extension: Single [bool expression]
    .description
        Input is object, to allow for other truthy values
    .example
       PS> 4, $true, 1, 0.0, $false, 0 | _FormatDictItem_Boolean
    .example
       PS> 4, $true, 1, 0.0, $false, 0 | _FormatDictItem_Boolean
    .example
       PS> '', ' ', $null, ,@(), ,$null, $true, $false, 1, 2, 0
       | _FormatDictItem_Boolean

    #>
    [cmdletbinding()]
    param(
        #  color instance
        [AllowNull()]
        [AlloWEmptyCollection()]
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [object]$InputObject,

        # when not strict, fallback to a truthy test
        # instead of coercing nulls, numbers, etc.
        [switch]$Strict
    )
    process {
        if ($Strict -and $InputObject -isnot 'boolean') {
            'Non-Boolean passed: {0} as {1}' -f @(
                $InputObject
                $InputObject.GetType()
            ) | Write-Error
            return
        }
        $truthy = [bool]$InputObject # might be redundant, might help some cases
        $color = $truthy ? 'green' : 'red'

        Write-Color -fg $color -t $InputObject -ea continue
    }
}
function _FormatDictItem_TrueNull {
    <#
    .synopsis
        Format-Dict Extension: True nulls or blank text?  [bool expression]
    .description
        .
    .notes

    .example
        🐒> _FormatDictItem_TrueNull
            [true $null]
    .example
        🐒> $null, @() | _FormatDictItem_TrueNull
            [true $null]
            [␀]
    .example
        🐒> _FormatDictItem_TrueNull
            [true $null]

    .example
       🐒> '', $null, @(), $null | _FormatDictItem_TrueNull -Debug
            DEBUG: Not null 'string'
            [␀]
            [true $null]
            DEBUG: Not null 'System.Object[]'
            [␀]
            [true $null]

    #>
    [OutputType('string')]
    [cmdletbinding()]
    param(
        #  color instance
        [Parameter(ValueFromPipeline, Position = 0)]
        [object]$InputObject
    )
    process {
        if ($null -eq $InputObject) {

            $script:__fdItemStr['trueNull']
            # | write-color 'gray40'
            # '[true null]'
            return
        }
        Write-Debug "Not null '$($InputObject.GetType())'"
        '[invalid]' | write-color -fg gray60
        return
        $script:__fdItemStr['null']
        # | write-color 'gray60'
    }
}

function _FormatDictItem_BlankText {
    <#
    .synopsis
        Format-Dict Extension: control char only or blank text?  [null scalar]
    .description
        with args, prints:
            [␀] or [truenull]

        without args, prints:
            [truenull]
    .notes
        sdfsd
    .example
       PS> $null | _FormatDictItem_Boolean
        [␀] or [truenull]
    #>
    [OutputType('string')]
    [cmdletbinding()]
    param(
        [Alias('Text')]
        [Parameter(Position = 0, ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [string]$InputObject
    )
    process {
        if ($null -eq $InputObject) {
            _FormatDictItem_TrueNull
            return
        }
        if ($InputObject -eq '') {
            return $__fdItemStr['trueEmptyStr']
        }
        if ( [String]::IsNullOrEmpty($InputObject) ) {
            return $__fdItemStr['blankStr']
        }
        if ( [String]::IsNullOrWhiteSpace( $InputObject)) {
            return $__fdItemStr['whitespaceStr']
        }
        # otherwise control chars? non-control whitespace should be triggered above ?
        if ($true) {
            $kwargs = @{
                InputText = $InputObject
                # PreserveWhitespace = $true
                # PreserveNewline = $true
                # Options = @{}
            }

            Format-ControlChar @kwargs
            return
        }
        return $InputObject
        # no?
    }
}

# function _FormatDictItem_EmptyCollection {
#     <#
#     .synopsis
#         Format-Dict Extension: emtpy collection [object[]]
#     .description
#         .
#     .notes
#         sdfsd
#     .example
#        PS> $null | _FormatDictItem_Boolean
#         [␀] or [truenull]
#     #>
#     [OutputType('string')]
#     [cmdletbinding()]
#     param(
#         [Alias('Text')]
#         [Parameter(Position = 0, ValueFromPipeline)]
#         [AllowNull()]
#         [AllowEmptyCollection()]
#         [AllowEmptyString()]
#         [string]$InputObject
#     )
#     process {
#         if ($null -eq $InputObject) {
#             _FormatDictItem_TrueNull
#             return
#         }
#         if ($InputObject -eq '') {
#             return $__fdItemStr['trueEmptyStr']
#         }
#         if ( [String]::IsNullOrEmpty($InputObject) ) {
#             return $__fdItemStr['blankStr']
#         }
#         if ( [String]::IsNullOrWhiteSpace( $InputObject)) {
#             return $__fdItemStr['whitespaceStr']
#         }
#         # otherwise control chars? non-control whitespace should be triggered above ?
#         if ($true) {
#             $kwargs = @{
#                 InputText = $InputObject
#                 # PreserveWhitespace = $true
#                 # PreserveNewline = $true
#                 # Options = @{}
#             }

#             Format-ControlChar @kwargs
#             return
#         }
#         return $InputObject
#         # no?
#     }
# }



function _FormatDictItem_ColorSingle {
    <#
    .synopsis
        Format-Dict Extension: Single [rgbcolor]
    .example
       PS> [rgbcolor]'red'
        | _FormatDictItem_ColorSingle

        ␛[38;2;255;0;0mHSL(0,100%,50%)␛[39m␠␛[48;2;255;0;0mHSL(0,100%,50%)␛[49m
    #>
    [cmdletbinding()]
    param(
        #  color instance
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [PoshCode.Pansies.RgbColor]$InputObject
    )
    process {
        $InputObject | _format_HslColorString Compress
    }
}

$__RegisteredFormatDictExtension = @(
    @{
        TypeName = 'PoshCode.Pansies.RgbColor'
        Function = '_FormatDictItem_ColorSingle'
    }
    @{
        TypeName = 'Boolean'
        Function = '_FormatDictItem_Boolean'
    }
    @{
        TypeName      = [Collections.IEnumerable]
        ChildTypeName = 'PoshCode.Pansies.RgbColor'

        Function      = '_FormatDictItem_ColorList'
    }
    @{
        TypeName = 'System.IO.FileInfo'
        Function = '_FormatDictItem_Filepath'
    }
    @{
        TypeName = 'System.IO.DirectoryInfo'
        Function = '_FormatDictItem_Filepath'
    }
)
# Write-Error 'move format dict to nin'
function Format-Dict {
    <#
    .synopsis
        experimental. 'pretty print dict', using Pwsh 7
    .notes
        see: Dev.Nin\_FormatDictItem_ColorSingle

        tags: console, ANSI, color, formatting
        - [ ] todo: passthru to see currrent config

    ## for '_FormatDictItem_*' functions, should handling be:

        [1] assert types strict, or
        [2] silently ignore type mismatches, output nothing
        [3] zero checking, so mismatch like text to _TrueNull is still gray

        - [ ] print to other streams:
            How can I remove the need to do 'format-dict | out-string | out-debug'

        - [ ] future: recurse
        - [ ] sketch. not optimizied at all
        - [ ] doesn't have recursion
        - [ ] coerce values better?

    .link
        Dev.Nin\_FormatDictItem_ColorSingle
    #>
    [Alias('fDict')]
    [outputtype( [string[]] )]
    [cmdletbinding()]
    param(
        # Dict to print
        [Alias(
            # 'Dev.Format-Dict'
            # 'Ansi.Format-Dict'
        )]
        [parameter(
            Mandatory, Position = 0,
            ValueFromPipeline
        )][object]$InputObject, # instead, whichever type allows most dict types


        [parameter()][String]$Title,
        # extra options
        [Parameter()]
        [hashtable]$Options = @{}
    )
    begin {
        $ColorType = @{
            'KeyName' = 'SkyBlue'
            Fg        = 'gray80'
            FgDim     = 'gray50'
            FgDim2    = 'gray30'
        }

        $ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})


        $Config = @{
            AlignKeyValuePairs    = $true
            FormatControlChar     = $true
            TruncateLongChildren  = $True
            ColorChildType        = $false # not finished
            BackgroundColorValues = $true
            Title                 = 'Dict'
            DisplayTypeName       = $true
        }
        if ($Title) {
            # $Options['Title'] = $Title
            # @($null)?['b']

            # prevednts/fixes all errors
            $Options = Join-Hashtable $Options (@{'Title' = $Title })
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})
        $Config.JoinOuter = @{
            OutputPrefix = "`n${fg:\gray30}{0} = {{`n" -f @($Config.Title ?? 'Dict')
        }

        $Template = @{
            # todo: replace template with template lib
            OutputPrefix = @(
                # was: `n$($ConfigTitle) = {{ {0}`n"
                "`n"
                $Config.Title
                " = {{ {0}`n"
            ) -join ''
        }

        # @{a=3} | Format-dict -Options @{'DisplayTypeName'=$false}
        # OutputPrefix         = "`nDict = {`n"
    }
    process {
        $metaDebug = [ordered]@{
            FullName = ($InputType)?.GetType().FullName
            Count    = $InputType.Count
            # FirstChild =
        }

        try {
            # $metaDebug['firstChild'] = ($InputType)?.GetType() ?? '$null'
            $metaDebug['firstChild'] = @($InputType)[0]?.GetType().FullName ?? '$null'
        } catch {
            $metaDebug['firstChild'] = 'failed'

        }

        [int]$LongestName = $InputObject.Keys | ForEach-Object { $_.Length } | Measure-Object -Maximum | ForEach-Object Maximum
        [bool]$disableGetEnumerate = $false
        # todo: UX: make dict render on a single line when empty
        # 1 / 0

        if ($false) {

            try {

                $typeNameStr = if (!($Config.DisplayTypeName)) {
                    ''
                } else {
                    $InputObject.GetType() | Format-TypeName -WithBrackets | Write-Color gray60
                }
            } catch {
                $typeNameStr = ''
            }
        }
        $typeNameStr = ( ($InputObject)?.GetType() ?? 'typeNameStr')

        $joinOuter_Splat = @{

            Separator    = "`n"
            # OutputPrefix = $Template.OutputPrefix # was: "`nDict = {`n"
            OutputPrefix = $Template.OutputPrefix -f @(
                $typeNameStr ?? ' ' # todo: replace with Invoke-Template
            )
            # OutputPrefix = $Config.JoinOuter.OutputPrefix
            OutputSuffix = "${fg:clear}`n}" # was: "`n}`n"
        }
        # if ($false) {
        #     if ($Config.DisplayTypeName) {
        #         $joinOuter_Splat['OutputPrefix'] = $Template.OutputPrefix -f @(

        #         )

        #     }
        # }

        Write-Debug 'TypeInfo? '
        # throw '/here'
        if ($InputObject -is [Collections.IDictionary]) {
            Write-Color green -t 'Yes'
            | str Prefix 'Is: [IDictionary]? ' | Write-Color 'gray80' | Write-Debug
        } else {
            Write-Color red -t 'No'
            | str Prefix 'Is: [IDictionary]? ' | Write-Color 'gray80' | Write-Debug
        }
        if ($InputObject -is [Collections.IEnumerable]) {
            Write-Color green -t 'Yes'
            | str Prefix 'Is: [IEnumerable]? ' | Write-Color 'gray80' | Write-Debug
        } else {
            Write-Color red -t 'No'
            | str Prefix 'Is: [IEnumerable]? ' | Write-Color 'gray80' | Write-Debug
        }

        if ($InputObject -is [Collections.IDictionary]) {
            $TargetObj = $InputObject
        } elseif ($InputObject -is [PSCustomObject]) {
            $objAsHash = [ordered]@{}
            $InputObject.psobject.properties | ForEach-Object {
                $SafeKey = $_.Name ?? '[null]'
                $objAsHash[ $SafeKey ] = $_.Value
            }
            # $objAsHash
            # $targetObject = $obj AsHash
            # temp disable
            $TargetObj = $objAsHash

            # $TargetObj = $InputObject
        } elseif ($InputObject -is [Collections.DictionaryEntry]) {
            $disableGetEnumerate = $true
            # $hash = @{}
            # Get-ChildItem env: | ForEach-Object {
            #     $hash[$_.key] = $_.Value
            # }
            # $TargetObj = $hash
        } else {
            $TargetObj = $InputObject
        }
        # // one final test
        if (!($InputObject.psobject.Methods['GetEnumerator'])) {
            $disableGetEnumerate = $true
            "MissingMethodError: type '{0}' has no '.GetEnumerator'" -f @(
                $InputObject.GetType().FullName
            ) | Write-Warning
            # ) | Write-Verbose

            # $hash = @{}
            # $disableGetEnumerate = $True
            # $InputObject | iterProp -infa ignore | ForEach-Object {
            #     $hash[ $_.Name ] = $_.Value
            # }
            # $TargetObject = $hash # todo: better to be a hash or a psco ?
        }
        $metaDebug['disableGetEnumerate'] = $disableGetEnumerate
        $metaDebug['TargetObject'] = ($TargetObj)?.GetType() ?? '$Null'
        $metaDebug | Format-Table | Out-String | Write-Debug

        $ToEnumerate = if (!  $disableGetEnumerate ) {
            $TargetObj.GetEnumerator()
        } else {
            $TargetObj
        }


        $ToEnumerate | ForEach-Object {
            # $TargetObj.GetEnumerator() | ForEach-Object {
            $outPrefix = @(
                if ($Config.AlignKeyValuePairs) {
                    $paddedKey = (($_.Key) ?? '').padright($LongestName, ' ')
                    # $_.Key | Write-Color $ColorType.KeyName
                    $paddedKey | Write-Color $ColorType.KeyName
                } else {
                    $_.Key | Write-Color $ColorType.KeyName
                }
                ' = '
            ) -join ''
            $joinPair_splat = @{
                InputObject  = if ($Config.FormatControlChar) {
                    $_.Value | Format-ControlChar
                } else {
                    if (! $Config.BackgroundColorValues ) {
                        $_.Value
                    } else {
                        $_.Value | Write-Color black -bg darkpink3
                        # $_.Value | New-Text -bg 'lightpink'
                    }
                }
                # if($Config.TruncateLongChildren) {

                # }

                OutputPrefix = $outPrefix
                | Format-IndentText -Depth 1 -IndentString '  '



                # '#84747B'
                DoubleQuote  = $true
            }

            if ($Config.ColorChildType) {
                $joinPair_Splat['InputObject'] = $joinPair_Splat['InputObject']
                | hi 'true' 'blue'


            }

            if ($Config.TruncateLongChildren) {
                # $joinPair_splat['InputObject'] = $joinPair_splat['InputObject']
                # | ShortenString -MaxLength ([console]::WindowWidth - 20)

                # note: this doesn't calculate correctly because of escapes
                Join-String @joinPair_splat
                | ShortenString -MaxLength ([console]::WindowWidth + 20)
                return
            }

            Join-String @joinPair_splat


        } | Join-String @joinOuter_Splat


    }
}

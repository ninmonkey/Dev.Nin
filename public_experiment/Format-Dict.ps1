# if ($BadDebugEnabled) {

$experimentToExport.function += @(
    'Format-Dict'
)
$experimentToExport.alias += @(
    'Dev.Format-Dict'
    # 'Ansi.Format-Dict'
    # 'New-Sketch'
)
# }

function _FormatDictItem_Filepath {
    <#
    .synopsis
        Format-Dict Extension: RelativeFilepaths
    #>
    param([string]$Path)
    process {
        if (Test-Path $Path) {
            Format-RelativePath -InputObject $Path
        }
        else {
            $Path
        }
    }
}

$__RegisteredFormatDictExtension = @(
    @{
        TypeName = 'System.IO.DirectoryInfo'
        Function = '_FormatDictItem_Filepath'
    }
    @{
        TypeName = 'System.IO.FileInfo '
        Function = '_FormatDictItem_Filepath'
    }
)
function Format-Dict {
    <#
    .synopsis
        experimental. 'pretty print dict', using Pwsh 7
    .notes
        tags: console, ANSI, color, formatting
        - [ ] print to other streams:
            How can I remove the need to do 'format-dict | out-string | out-debug'

        - [ ] future: recurse
        - [ ] sketch. not optimizied at all
        - [ ] doesn't have recursion
        - [ ] coerce values better?
    #>
    # [outputtype( [string[]] )]
    [cmdletbinding()]
    param(
        # Dict to print
        [Alias(
            'Dev.Format-Dict'
            # 'Ansi.Format-Dict'
        )]
        [parameter(
            Mandatory, Position = 0,
            ValueFromPipeline
        )][object]$InputObject, # instead, whichever type allows most dict types

        # extra options
        [Parameter()]
        [hashtable]$Options
    )
    begin {
        $ColorType = @{
            'KeyName' = 'SkyBlue'
        }

        $ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})


        $Config = @{
            AlignKeyValuePairs    = $true
            FormatControlChar     = $true
            TruncateLongChildren  = $True
            ColorChildType        = $false # not finished
            BackgroundColorValues = $true
            PrefixLabel           = 'Dict'
            DisplayTypeName       = $true
        }
        $Config = Join-Hashtable $Config ($Options.Config ?? @{})
        $Config.JoinOuter = @{
            OutputPrefix = "`n{0} = {{`n" -f @($Config.PrefixLabel ?? 'Dict')
        }

        $Template = @{
            # todo: replace template with template lib
            OutputPrefix = "`n$($Config.PrefixLabel) = {`n"
        }

        if ($Config.DisplayTypeName) {
            $Template.OutputPrefix = "`n$($Config.PrefixLabel) = {{ {0}`n"
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
        }
        catch {
            $metaDebug['firstChild'] = 'failed'

        }

        [int]$LongestName = $InputObject.Keys | ForEach-Object { $_.Length } | Measure-Object -Maximum | ForEach-Object  Maximum
        [bool]$disableGetEnumerate = $false
        # todo: UX: make dict render on a single line when empty
        # 1 / 0

        $typeNameStr = if (!($Config.DisplayTypeName)) {
            ''
        }
        else {
            $InputObject.GetType() | Format-TypeName -WithBrackets | Write-Color gray60
        }
        $joinOuter_Splat = @{

            Separator    = "`n"
            # OutputPrefix = $Template.OutputPrefix # was: "`nDict = {`n"
            OutputPrefix = $Template.OutputPrefix -f @($typeNameStr)
            # OutputPrefix = $Config.JoinOuter.OutputPrefix
            OutputSuffix = "`n}" # was: "`n}`n"
        }
        if ($false) {
            if ($Config.DisplayTypeName) {
                $joinOuter_Splat['OutputPrefix'] = $Template.OutputPrefix -f @(

                )

            }
        }

        Write-Debug 'Type? '
        if ($InputObject -is [Collections.IDictionary]) {
            Write-Color green -t 'Yes'
            | str Prefix 'Is: [IDictionary]? ' | Write-Color 'gray80' | Write-Debug
        }
        else {
            Write-Color red -t 'No'
            | str Prefix 'Is: [IDictionary]? ' | Write-Color 'gray80' | Write-Debug
        }
        if ($InputObject -is [Collections.IEnumerable]) {
            Write-Color green -t 'Yes'
            | str Prefix 'Is: [IEnumerable]? ' | Write-Color 'gray80' | Write-Debug
        }
        else {
            Write-Color red -t 'No'
            | str Prefix 'Is: [IEnumerable]? ' | Write-Color 'gray80' | Write-Debug
        }

        if ($InputObject -is [Collections.IDictionary]) {
            $TargetObj = $InputObject
        }
        elseif ($InputObject -is [PSCustomObject]) {
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
        }
        elseif ($InputObject -is [Collections.DictionaryEntry]) {
            $disableGetEnumerate = $true
            # $hash = @{}
            # Get-ChildItem env: | ForEach-Object {
            #     $hash[$_.key] = $_.Value
            # }
            # $TargetObj = $hash
        }
        else {
            $TargetObj = $InputObject
        }
        # // one final test
        if (!($InputObject.psobject.Methods['GetEnumerator'])) {
            $disableGetEnumerate = $true
            "MissingMethodError: type '{0}' has no '.GetEnumerator'" -f @(
                $InputObject.GetType().FullName
            ) | Write-Debug -ea continue
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
        $metaDebug | Format-Table | Out-String | Write-Information
        $metaDebug | Format-Table | Out-String | Write-Debug

        $ToEnumerate = if (!  $disableGetEnumerate ) {
            $TargetObj.GetEnumerator()
        }
        else {
            $TargetObj
        }


        $ToEnumerate | ForEach-Object {
            # $TargetObj.GetEnumerator() | ForEach-Object {
            $outPrefix = @(
                if ($Config.AlignKeyValuePairs) {
                    $paddedKey = (($_.Key) ?? '').padright($LongestName, ' ')
                    # $_.Key | Write-Color $ColorType.KeyName
                    $paddedKey | Write-Color $ColorType.KeyName
                }
                else {
                    $_.Key | Write-Color $ColorType.KeyName
                }
                ' = '
            ) -join ''
            $joinPair_splat = @{
                InputObject  = if ($Config.FormatControlChar) {
                    $_.Value | Format-ControlChar
                }
                else {
                    if (! $Config.BackgroundColorValues ) {
                        $_.Value
                    }
                    else {
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

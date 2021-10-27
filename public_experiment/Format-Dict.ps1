# if ($BadDebugEnabled) {

$experimentToExport.function += @(
    'Format-Dict'
)
$experimentToExport.alias += @(
    'Dev.Format-Dict'
    'Ansi.Format-Dict'
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
        - [ ] future: recurse
        - [ ] sketch. not optimizied at all
        - [ ] doesn't have recursion
        - [ ] coerce values better?
    #>
    # [outputtype( [string[]] )]
    [cmdletbinding()]
    param(
        # Dict to print
        [Alias('Dev.Format-Dict', 'Ansi.Format-Dict')]
        [parameter(
            Mandatory, Position = 0,
            ValueFromPipeline
        )][object]$InputObject, # instead, whichever type allows most dict types

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
            OutputPrefix         = "`nDict = {`n"
            OutputPrefixWithType = "`nDict = {{ {0}`n"
        }
    }
    process {
        [int]$LongestName = $InputObject.Keys | ForEach-Object { $_.Length } | Measure-Object -Maximum | ForEach-Object  Maximum
        $disableGetEnumerate = $false
        # todo: UX: make dict render on a single line when empty
        $joinOuter_Splat = @{

            Separator    = "`n"
            OutputPrefix = $Template.OutputPrefix # was: "`nDict = {`n"
            # OutputPrefix = $Config.JoinOuter.OutputPrefix
            OutputSuffix = "`n}" # was: "`n}`n"
        }
        if ($Config.DisplayTypeName) {
            $joinOuter_Splat['OutputPrefix'] = $Template.OutputPrefixWithType -f @(
                $InputObject.GetType() | Format-TypeName -WithBrackets | write-color gray60
            )
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

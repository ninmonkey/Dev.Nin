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
        )]$InputObject, # instead, whichever type allows most dict types

        [Parameter()]
        [hashtable]$Options
    )
    begin {
        $ColorType = @{
            'KeyName' = 'SkyBlue'
        }

        $ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})


        $Config = @{
            AlignKeyValuePairs   = $true
            FormatControlChar    = $true
            TruncateLongChildren = $True
            ColorChildType       = $false # not finished
        }
        $Config = Join-Hashtable $Config ($Options.Config ?? @{})
    }
    process {
        [int]$LongestName = $InputObject.Keys | ForEach-Object { $_.Length } | Measure-Object -Maximum | ForEach-Object  Maximum
        $joinOuter_Splat = @{
            Separator    = "`n"
            OutputPrefix = "`nDict = {`n"
            OutputSuffix = "`n}`n"
        }


        $InputObject.GetEnumerator() | ForEach-Object {
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
                    $_.Value
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
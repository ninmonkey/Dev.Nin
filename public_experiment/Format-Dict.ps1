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
        - [ ] sketch. not optimizied at all
        - [ ] doesn't have recursion
        - [ ] coerce values better?
    #>
    # [outputtype( [string[]] )]
    [cmdletbinding()]
    param(
        # Dict to print
        [Alias('Dev.Format-Dict', 'Ansi.Format-Dict')]
        [parameter(Mandatory, Position = 0)]
        $InputObject # instead, whichever type allows most dict types
    )
    process {
        $LongestName = $InputObject.Keys | Measure-Object -Maximum | ForEach-Object Maximum
        $joinOuter_Splat = @{
            Separator    = "`n"
            OutputPrefix = "`nDict = {`n"
            OutputSuffix = "`n}`n"
        }

        $InputObject.GetEnumerator() | ForEach-Object {
            $outPrefix = @(
                $_.Key | Write-Color 'SkyBlue'
                ' = '
            ) -join ''
            $joinPair_splat = @{
                InputObject  = $_.Value | Format-ControlChar

                OutputPrefix = $outPrefix
                | Format-IndentText -Depth 1 -IndentString '  '



                # '#84747B'
                DoubleQuote  = $true
            }

            Join-String @joinPair_splat
        } | Join-String @joinOuter_Splat


    }
}
using namespace Management.Automation

$experimentToExport.function += @(
    'Invoke-TestTabExpansionResults'
)
$experimentToExport.alias += @(    
    'DevTool💻-Params-TestTabExpansionResults' # actual command
    'Example🔖-TestTabExpansionResults' # example usage
)

function Invoke-TestTabExpansionResults {
    <#
    .synopsis
        Enumerate a string, get TabExpansion results for every substring
    .description
        .
    .notes
        tags: 
            'DevTool💻, 'Example🔖'
        todo:
        - [ ] custom type: nicer output with lists

    .example
        🐒> Example🔖-TestTabExpansionResults
    .outputs
          [string | None]

    #>
    [Alias('DevTool💻-Params-TestTabExpansionResults')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [string]$InputScript
    )

    process {
        # expansion is not base-0
        1..($InputScript.Length) | ForEach-Object {
            $curCol = $_
            try {
                $res = (TabExpansion2 -inputScript $InputScript -cursorColumn $curCol -ea break)
            }
            catch {
                Write-Warning "Error: $_"
                $res = $null ?? "[`u{2400}]" # do not quit
            }
            # [pscustomobject]@{
            #     Step     = $curCol
            #     Matching = if ($res) { $res.CompletionMatches }
            #     Object   = $res
            # }
            $resMatch = $res.CompletionMatches
            [pscustomobject]@{
                PSTypeName     = 'Nin.TabExpansionQuery'
                Column         = $curCol
                CompletionText = $resMatch.CompletionText ?? "[`u{2400}]"
                ListItemText   = $resMatch.ListItemText ?? "[`u{2400}]"
                ResultType     = $resMatch.ResultType ?? "[`u{2400}]"
                ToolTip        = $resMatch.ToolTip ?? "[`u{2400}]"
                Matching       = if ($res) { $(res)?.CompletionMatches.Matching ?? "[`u{2400}]" }
                Object         = $res ?? "[`u{2400}]"
            }
        }
    }

}


function Invoke-TabCompletionColumnResultsExample {
    <#
    .synopsis
        example usage, only export alias
    #>
    [Alias(
        # 'DevTool💻-Params-TestTabExpansionResults', 
        'Example🔖-TestTabExpansionResults'
    )]
    [CmdletBinding()]
    param()
    
    $res = (TabExpansion2 -inputScript ('[regex]::new') -cursorColumn 12)
    $res | Format-List
    Hr

    (TabExpansion2 -inputScript ('[regex]::new') -cursorColumn 12) | iProp

    Hr

    $res2 = $res.CompletionMatches
    $res2 | Format-List

    Hr
    $res2 | iProp

    $results = enumerateTabCompleteColumns 'ls '
    $FormatEnumerationLimit = -1
    $results | Format-Table
    $FormatEnumerationLimit = 4

}


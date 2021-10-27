# C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\buffer\2021-07
# if ($BadDebugEnabled) {

$experimentToExport.function += @(
    'New-DevFileSketchItem'
    'New-SketchItem'
)
$experimentToExport.alias += @(
    'NewBufferItem'
    'Dev.New-Sketch'
    # 'New-Sketch'
)
# }

function New-DevFileSketchItem {
    <#
    .synopsis
        create and open a new file, like
            C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\buffer\2021-07
    .description
        create a new file name using the pattern

        future:
            - [ ] Get-DevFileSketchItem:  version of the func that quickly grabs files from there
            - [ ] Edit-DevFileSketchItem: version of the func that quickly grabs files from there
    .example
        PS>
    .notes
        .
    #>
    [Alias('Dev.New-Sketch', 'NewBufferItem')]
    [cmdletbinding( ConfirmImpact = 'high', PositionalBinding = $false, SupportsShouldProcess)]
    param (
        # Name
        [Alias('Folder')]
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('PowerShell', 'Pwsh', 'PowerQuery', 'Pq', 'PowerBI', 'Pbi')]
        [string]$Location,

        # Labels
        [Parameter(Position = 1)]
        [ValidateSet('None', '—', '•', '⁞', '⇢', '⇽', '⇾', '┐', '⚙', '🌎', '🎨', '🐛', '💡', '📋', '📹', '🔑', '🔥', '🕷', '🕹', '🖥',
            'ArgCompleter🧙‍♂️', 'Cli_Interactive🖐', 'Conversion📏', 'DevTool💻', 'ExamplesRef📚', 'Experimental🧪', 'Format🎨', 'My🐒', 'NativeApp💻', 'Prompt💻', 'Regex🔍', 'Style🎨', 'TextProcessing📚', 'UnderPublic🕵️‍♀️', 'Validation🕵')]
        [string[]]$Label,

        # Actual filename
        [Parameter(Mandatory, Position = 2, ValueFromRemainingArguments)]
        [string]$FileName,


        # PassThru : also return new fileinfo object
        [Parameter()][switch]$PassThru

    )
    begin {
        # todo:minimal: note: year is hard coded
        $Config = @{
            # Root Path. Could Change language
            DocsRoot = Get-Item -ea stop "$Env:UserProfile\SkyDrive\Documents\2021"
            # $Env:UserProfile\SkyDrive\Documents\2021\Powershell\buffer\2021-07
        }

        $LocationPath = @{
            # 'PowerShell' = gi -ea stop \Powershell\buffer"
            'PowerQuery' = ( Join-Path $Config.DocsRoot 'Power BI\buffer' )
            'Power-BI'   = ( Join-Path $Config.DocsRoot 'Power BI\buffer' )
            'PowerShell' = ( Join-Path $Config.DocsRoot 'PowerShell\buffer' )
            # Powershell\buffer\2021-10
        }
        $LocationPath += @{
            'Pq'   = ( Join-Path $Config.DocsRoot 'Power BI\buffer' )
            'Pbi'  = ( Join-Path $Config.DocsRoot 'Power BI\buffer' )
            'Pwsh' = ( Join-Path $Config.DocsRoot 'PowerShell\buffer' )
        }
        $Template = @{
            GeneratedFile = @'
/*
    About: {{Sketch}}
    Date:  {{Date}}
    Tags:  {{Tags}}
*/


'@
        }
        # C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\buffer\2021-10
        # $Template = @{
        #     # goal: '\2021-10\Regex-WhereMini\Where-RegexMatch.ps1'
        #     Filepath = @(
        #         $LocationPath
        #     )

        # }

        $Location | Write-Debug
        hr
        $Config | Write-Debug
    }
    process {

        # $LocationPath.Keys
        if ($LocationPath.Keys -notcontains $Location) {
            throw "Location not implemented: '$Location' not in $($LocationPath.Keys)"
        }
        # $NewItemPath = $LocationPath['$']
        # $x = 20
        $target = @( 'foo.ps1' | Write-Color green) | Join-String
        $operation = @( 'c:\foo\bar' | Write-Color pink) | Join-String
        # $target = 'target' ; $operation = 'operation'

        # $NewItemPath

        'From: '
        $metaShouldProc = @{
            Target    = $target
            Operation = $operation
            Location  = $Location
        }
        Format-Dict $metaShouldProc

        # Join-String -DoubleQuote -op 'Target' -inputObject

        if ($PSCmdlet.ShouldProcess($target, $operation)) {
            $target
            $operation

        }
        # $PSCmdlet.ShouldProcess

    }
    end {}
}
# $BadDebugEnabled = $true
# $BadDebugEnabled = $null
if ($false) { #//$BadDebugEnabled) {

}
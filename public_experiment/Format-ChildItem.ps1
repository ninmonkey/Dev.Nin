#Requires -Version 7.0.0
using namespace Management.Automation

$experimentToExport.function += @(
    'Format-ChildItemSummary'
)
$experimentToExport.alias += @(
    'Summarize.Filepath' # ?
    'LsNew'
)

function Format-ChildItemSummary {
    <#
    .synopsis
        summarize newest files
    .notes
            .
    .example
        🐒> lsnew
        ----------------------------------------------
        extension-host.log [16 KB], window.log [831 B]
        ----------------------------------------------
    #>
    [Alias('LsNew', 'Summarize.Filepath')]
    [outputtype('string')]
    [cmdletbinding()]
    param(
        # base path
        [Parameter()]
        [string]$Path = '.',

        # max / item cut off
        [Alias('LimitItems')]
        [Parameter()]
        [uint]$MaxItems = 10,

        # for : ls . -Directory
        [Parameter()]
        [switch]$DirectoryOnly,

        # for : ls . -File
        [Parameter()]
        [switch]$FileOnly,

        # filtering mode
        [Parameter()]
        [validateSet('Files', 'Directories', 'Both')]
        [string]$FilterMode,

        # hash of extra options
        [Alias('Options')]
        [Parameter()]
        [hashtable]$Config
    )
    process {
        if ($null -ne $Config.Prefix) {
            $Config.Prefix
        }
        else {
            hr
        }

        $childSplat = @{
            Path = $Path
        }
        switch ($FilterMode) {
            'Files' {
                $childSplat['File'] = $true
            }
            $FileOnly {
                $childSplat['File'] = $true
            }
            'Directories' {
                $childSplat['Directory'] = $true
            }
            $DirectoryOnly {
                $childSplat['Directory'] = $true
            }
            default {}
        }

        $newest = Get-ChildItem @childSplat
        | Sort-Object lastWriteTime -desc -Top $MaxItems

        # $newest = Get-ChildItem $Path | Sort-Object lastWriteTime -desc -Top $MaxItems
        $newest
        | Join-String {
            $curItem = $_
            if (Test-IsDirectory $curItem) {
                $typeColor = 'paleGoldenRod' #DBDCA8
                $typeIcon = '📁'
            }
            else {
                $TypeColor = 'gray90'
            }

            '{2}{0} [{1}]' -f @(
                $curItem.name | Write-Color $TypeColor
                $curItem.Length | Format-FileSize | Write-Color 'gray60'
                '{0}' -f @(
                    if (! $TypeIcon) {
                        $null
                    }
                    else {
                        $TypeIcon, ' ' -join ''
                    }
                )
            )
        } -sep ', '
        #| write-color 'darkred'
        | str Csv
        hr
    }
}

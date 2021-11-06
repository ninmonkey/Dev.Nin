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
        [parameter(
            ParameterSetName = 'OnlyConfig'
        )]
        [switch]$GetConfig,

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
        [Alias('Config')]
        [Parameter()]
        [hashtable]$Options
    )
    begin {
        # $ColorType = @{
        #     'KeyName' = 'SkyBlue'
        # }
        # $ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})
        $Config = @{
            Prefix    = $Null
            DisableHr = $false # todo __doc__ wil make discovery easier
        }
        $Config = Join-Hashtable $Config ($Options ?? @{})

        $Template = @{
            # todo: replace template with template lib
            OutputPrefix = @(
                # was: `n$($ConfigTitle) = {{ {0}`n"
                "`n"
                $ConfigTitle
                " = {{ {0}`n"
            ) -join ''
        }

        # @{a=3} | Format-dict -Options @{'DisplayTypeName'=$false}
        # OutputPrefix         = "`nDict = {`n"

        if ($GetConfig) {
            $Config.Template = $template
            $config
            return
        }
    }

    process {
        if ($null -ne $Config.Prefix) {
            $Config.Prefix
        } else {
            if (!($Config.DisableHr)) {
                hr
            }
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

        if ($newunt -eq 0) {
            '∅'
            return
        }
        
        # $newest = Get-ChildItem $Path | Sort-Object lastWriteTime -desc -Top $MaxItems
        function __formatItem_Folder {
            <#
            .synopsis
                handles formatting directories for Format-ChildItemSummary
            #>
            param(
                [Parameter(Mandatory, Position = 0)]
                [object]$curItem
            )
            process {
                $ChildCountSingleDepth = Get-ChildItem -Path $curItem | len
                $typeColor = 'paleGoldenRod' #DBDCA8
                $typeIcon = '📁'
                $TemplateRender = '{2}{0} [{1}]' -f @(
                    $curItem.name | Write-Color $TypeColor
                    $ChildCountSingleDepth
                    | Write-Color 'gray60'
                    '{0}' -f @(
                        # if (! $TypeIcon) {
                        #     $null
                        # } else {
                        $TypeIcon
                        # , ' ' -join ''
                        # }
                    )
                
                )
                # 1 / 0
                $TemplateRender
            }
        }
        function __formatItem_File {
            <#
            .synopsis
                handles formatting filetypes for Format-ChildItemSummary
            #>
            param(
                [Parameter(Mandatory, Position = 0)]
                [object]$curItem
            )
            process {
                $TypeColor = 'gray90'
                '{2}{0} [{1}]' -f @(
                    $curItem.name | Write-Color $TypeColor
                    $curItem.Length | Format-FileSize | Write-Color 'gray60'
                    '{0}' -f @(
                        if (! $TypeIcon) {
                            $null
                        } else {
                            $TypeIcon, ' ' -join ''
                        }
                    )
                )
            }
        }
        
        $newest
        | Join-String {
            $curItem = $_
            if (Test-IsDirectory $curItem) {
                __formatItem_Folder $curItem
            } else {                
                __formatItem_File $curItem
            }
        } -sep ', '
        #| write-color 'darkred'
        | Where-IsNotBlank
        | str Csv

        if ($null -ne $Config.Suffix) {
            $Config.Prefix
        } else {
            if (!($Config.DisableHr)) {
                hr
            }
        }
    }
}

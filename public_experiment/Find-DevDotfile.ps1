using namespace System.Collections.Generic
$experimentToExport.function += 'Find-Dotfile_Experiment'
$experimentToExport.alias += 'FindDotfile'


function Find-Dotfile_Experiment {
    <#
  .synopsis
   try to find dotfiles
  .example
       _toastTimer 30m
  #>
    [alias('FindDotfile')]
    [cmdletbinding()]
    param(
        # TopLevelFile
        [Parameter()][switch]$FileAtBase,
        # TopLevelDir
        [Parameter()][switch]$DirectoryAtBase,

        # Everything that's a child of a '.folder' dot prefixed dir
        [Parameter()][switch]$ChildItems
    )

    begin {
        $Regex = @{}
        $Regex.DotPrefix = '^\..+'
    }

    process {
        $rootDirs = Get-ChildItem ~ -Directory -Force
        | Where-Object { $_.BaseName -match $Regex.DotPrefix }
        | Sort-Object Name

        if ($FileAtBase) {
            Get-ChildItem ~ -File -Force
            | Where-Object { $_.BaseName -match $Regex.DotPrefix }
            | Sort-Object Name
        }
        if ($DirectoryAtBase) {
            $rootDirs
        }
        if ($ChildItems) {
            Get-ChildItem -Path $rootDirs -Force -Recurse
        }
    }
}


IF ($FALSE) {
    # try to get total file counts of parents, this broke.
    $results ??= $parents | ForEach-Object {

        $curP = @{ 'Path' = Get-Item $curP }
        $curP['Children'] = Get-ChildItem -Path $curP -Force -Recurse
        $curP['TotalCount'] = ($curP['Children']).count
        $curP['TotalSize'] = $curP.Length | Measure-Object -Sum | ForEach-Object { $_.Sum / 1mb }
        "Path: $curP" | New-Text -fg green | ForEach-Object tostring | Write-Host
        $curP
    }
}

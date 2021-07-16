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

        [Parameter()][switch]$Recurse
    )

    begin {
        $Regex = @{}
        $Regex.DotPrefix = '^\..+'
        $results = [list[object]]::new()
    }

    process {
        if ($FileAtBase) {
            Get-ChildItem ~ -File -Force
            | Where-Object { $_.BaseName -match $Regex.DotPrefix }
            | Sort-Object Name
            | %{ $results.add }
        }
        if ($DirectoryAtBase) {
            Get-ChildItem ~ -Directory -Force
            | Where-Object { $_.BaseName -match $Regex.DotPrefix }
            | Sort-Object Name
        }
            | Where-Object { $_.BaseName -match $Regex.DotPrefix }
        if($Recurse) {
            ls ~
        }
    }
}
$results.add

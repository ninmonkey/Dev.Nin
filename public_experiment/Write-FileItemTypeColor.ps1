$experimentToExport.function += @(
    # ''
    # '_format-AnsiForFzf'
)
$experimentToExport.alias += @(
    # 'All' # breaks pester
    # 'Any'
)



<#
# function _write-AnsiBlock {

$files ??= Get-ChildItem 'G:\2021-github-downloads\' -Depth 3


# $files | ?str 'png' -Ends | Select-Object -First 10 | Join-String Name ', ' | WriteTextColor purple
# $files | ?str 'ps1' -Ends | Select-Object -First 10 | Join-String Name ', ' | WriteTextColor darkred
# $files | ?str 'md' -Ends | Select-Object -First 10 | Join-String Name ', ' | WriteTextColor lightyellow


$files
| Sort-Object LastWriteTime -Descending
| ForEach-Object {

    $cur = $_
    $color = $null
    if ($cur | Test-IsDirectory) {
        $color = 'blue'
    }
    $color ??= ($cur | ?str 'png' -Ends Extension) ? 'purple' : $Null
    $color ??= ($cur | ?str 'md' -Ends) ? 'orange' : $Null
    $color ??= ($cur | ?str 'ps1' -Ends Extension) ? 'pink' : $Null
    $color ??= ($cur | ?str '' -Ends Extension) ? 'red' : $Null
    $color ??= 'orange'
    WriteTextColor $color $cur.Name
} | Select-Object -First 50 | Join-String -sep ', '
#>

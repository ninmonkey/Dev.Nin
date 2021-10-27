'compare'
$currentFiles = Get-ChildItem . *.ps1 -Recurse
| Sort-Object LastWriteTime -Desc -Top 20
function _Test-IsChanged {
    <#
    .synopsis
        minimal file watcher, without events
    #>
    process {
        $currentFiles | ForEach-Object {
            $cur = $_
            if (! $cacheFileList.Contains( $cur.FullName )) {
                "$($cur.FullName) was not a key" | Write-Debug
                $cacheFileList[$cur.FullName] = $cur
                $true; return
            }
            if ( $cur.LastWriteTime -gt $cacheFileList[$cur.FullName].LastWriteTime ) {
                "$($cur.FullName) key is old" | Write-Debug
                $true; return
            }
            "$($cur.FullName) file is stll safe" | Write-Debug
        }
    }
}


  $AlwaysForce ??= $true
    if ($AlwaysForce) {
        Import-Module dev.nin -Force
    }
    function stale {
        $script:AlwaysForce = $True
    }

    # $ErrorActionPreference = 'continue'
    # $Error.clear()


    $sample = , (0..4), @{a = 2 }

    $error.count | str Prefix 'error count: '

    $Sample | Format-Dict

    $AlwaysForce = $false

# $script:__lastImportTime ??= [datetime]::Now

function _Test-ChangedSinceLastImport {
    <#
    .synopsis
        minimal file watcher, without events
    #>
    [cmdletbinding()]
    param()
    process {
        $getChildItemSplat = @{
            Path    = 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin'
            Recurse = $true
            Filter  = '*.ps1'
        }

        $currentFiles = Get-ChildItem   @getChildItemSplat
        | Sort-Object LastWriteTime -Desc

        $script:__lastImportTime | str prefix 'inside: '
        $currentFiles | ForEach-Object {
            $_ | ConvertTo-RelativePath | Sort-Object | Write-Information
            if ( $cur.LastWriteTime -gt $script:__lastImportTime ) {
                "$($cur.Name) key is old" | Write-Debug
                $true; return
            }
            "$($cur.Name) file is stll safe" | Write-Debug
        }
        $false; return
    }
    end {

    }
}

$script:__lastImportTime | str prefix 'outside: '
$isChanged = _Test-ChangedSinceLastImport -infa continue #Debug -Verbose
$IsChanged | str Prefix 'Changed? '
if ( $IsChanged ) {

    # Import-Module Dev.nin -Force
    hr 2
    $script:__lastImportTime = [datetime]::Now

}
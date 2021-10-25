
[hashtable]$__LazyImportState ??= @{
    IsCached = @{}
}

function Invoke-LazyImport {
    <#
    .synopsis
        super simple cached import
    .description
        should use a build system that watches files
        or even just watch files for saves, that'd be better.
    .uri
        Clear-LazyImport
    #>
    [cmdletbinding()]
    param(
        # Modules to load
        [Parameter(Mandatory, Position = 0)]
        [string[]]$ModuleName
    )
    process {
        $isCached = $script:__LazyImportState.IsCached
        $ModuleName | ForEach-Object {
            $curModule = $_
            $isStale = $isCached[$curModule] ?? $false
            "Stale?: '$curModule': '$isStale'" | Write-Information
            if ($isStale) {
                Import-Module -Name $ModuleName -Force -InformationAction cont -Verbose -Debug
                $isCached[$curModule] = $true
                "Loaded: '$curModule'" | Write-Information
            }
        }
    }
    end {}
}
function Clear-LazyImport {
    <#
    .synopsis
        invalidate/stale the cache
    .uri
        Invoke-LazyImport
    #>
    [alias('Stale')]
    [cmdletbinding()]
    $isCached = $script:__LazyImportState.IsCached
    $isCached.keys | ForEach-Object {
        Write-Debug "Clear: $_"
        $isCached[$_] = $false
    }
}

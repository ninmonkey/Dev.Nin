if ($false -and 'temp hack') {
    $experimentToExport.function += @(
        'Get-GistList'
        'Get-GistFiles'
    )
    $experimentToExport.alias += @(
        'GitTool💻-Gist-List'
        'GitTool💻-Gist-Files'
    )

    $script:__devGist_cache = $null # __doc__: replace with MiniModules\LazyCache
    $script:__devGist_Files_cache = @{}
}
else {
    $script:__devGist_cache ??= $null # __doc__: replace with MiniModules\LazyCache
    $script:__devGist_Files_cache ??= @{}
}

function Get-GistFiles {
    <#
    .synopsis
        List files for a given Gist
    .description
        caches responses per-hash, unless reset
        .
    .notes
        .
    .example
        PS>
    #>
    [ALias('GitTool💻-Gist-Files')]
    # [cmdletbinding(fromp PositionalBinding = $false, ValueFromPipeline)]
    [cmdletbinding(PositionalBinding = $false)]
    param (
        # hash for a specific gist
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Hash,

        # ClearCache
        [Alias('RefreshCache')]
        [switch]$ClearCache

        # ClearCache
        # [Alias('RefreshCache')]
        # [switch]$ClearCache
    )
    begin {

        [hashtable]$cacheMap = $script:__devGist_Files_cache ?? @{}
        if ($ClearCache) {
            Write-Debug "Clearing cache: '$Hash'"
            $cacheMap[$Hash] = $Null
        }

        if ($cacheMap.ContainsKey($Hash)) {
            Write-Debug "Contains cached key '$Hash'"
            $cachedValue = $cacheMap[$Hash]
            return
        }

        Write-Debug 'Invoking request'
        $cacheMap[$Hash] = gh gist view $Hash --files
        $script:__devGist_Files_cache = $cacheMap
        # $cacheMap[$Hash] = Invoke-NativeCommand 'gh' -args @(
        #     'gist', 'view',
        #     $Hash, '--files'
        # )

        # $script:__devGist_Files_cache[$Hash] = $cacheMap[$Hash]
    }
    process {

    }
    end {
        $query = $cacheMap[$Hash]
        $query
    }
}


function Get-GistList {
    <#
    .synopsis
        filter commands that do not have at least one alias
    .description
        caches full response unless reset
    .notes
        .
    .example
        PS> Get-NinCommand | Get-ParameterInfo | ? Aliases | Ft
    .example
        PS> gcm -Module (_enumerateMyModule) | Find-CommandWithParameterAlias | ft -AutoSize
    #>
    [ALias('GitTool💻-Gist-List')]
    [cmdletbinding(PositionalBinding = $false)]
    param (
        #
        # [Parameter(Position = 0, ValueFromPipeline)]
        # [string]$Name,

        # ClearCache
        [Alias('RefreshCache')]
        [switch]$ClearCache
    )
    begin {
        if ($ClearCache) {
            $script:__devGist_cache = $null
            Write-Debug 'Clearing Cache'

        }
        $script:__devGist_cache ??= Invoke-NativeCommand 'gh' -args @(
            'gist', 'list', '-L', 400
        )
        Write-Debug 'Request Cached'
        $cachedStdout = $script:__devGist_cache

    }
    process {

    }
    end {
        $query = $cachedStdout
        | ForEach-Object {
            $record = $_ -split '\t'
            $maybeDate = try { $record[4] -as 'datetime' } catch { $record[4] }
            [pscustomobject]@{
                Hash     = $record[0]
                Title    = $record[1]
                Files    = $record[2]
                IsPublic = $record[3]
                Date     = $maybeDate
            }
        }
        $query
    }
}

Get-GistList | Select-Object -First 1

# | Get-GistFiles -Verbose -Debug

# $stdout ??= gh gist list -L 300 #
# $query = $stdout
# | ForEach-Object {
#     $record = $_ -split '\t'
#     [pscustomobject]@{
#         Hash     = $record[0]
#         Title    = $record[1]
#         Files    = $record[2]
#         IsPublic = $record[3]
#         Date     = $record[4] -as 'datetime'
#     }
# }
# $query | Select-Object -First 4

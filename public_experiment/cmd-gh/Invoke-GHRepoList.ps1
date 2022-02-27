#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-GHRepoList'
        '_enumerateProperty_gh_repoList'
    )
    $experimentToExport.alias += @(
        'Gh->RepoList' # 'Invoke-GHRepoList'
    )
}

# allows script to be ran alone, or, as module import

$script:__gh_cache ??= @{}
function _enumerateProperty_gh_repoList {
    <#
    .synopsis
        get properties for 'gh repo list'
    #>
    param()
    $stdout = gh repo list --json *>&1 | Select-Object -Skip 1
    $stdout -replace '\s+', ''
}
# $props ??= _enumerateProperty_gh_repoList

function _processGHRepoListRecord {
    <#
    .synopsis
        not currently used, ConvertFrom-Json is importing enough
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline, Mandatory)]
        [string]$Json
    )
    process {
        $Json | ConvertFrom-Json
        | ForEach-Object {

        }
    }

}

function Invoke-GHRepoList {
    <#
    .synopsis
        experiment with querying /w gh cli
    .description
        original query was like this:
            gh repo list JustinGrote --source --json=$proplist --limit 999 | Set-Content 'api_response.json'
    .example
        Invoke-GHRepoList -infa Continue dfinke Public -Debug -Verbose
    .notes
        #6 WIP
        - [ ] future: autocomplete Owner
            - [ ] popuplate using my 'starred' and 'followed' people


        - [ ] filters:
            - [ ] isStarred, isFollowed (current user)
            - [ ] time / humanDateString: 'last1year' or 'after:2020'

        - [ ] future: autocompleter will have these tooltips
            FLAGS
                --archived          Show only archived repositories
                --fork              Show only forks
            -q, --jq expression     Filter JSON output using a jq expression
                --json fields       Output JSON with the specified fields
            -l, --language string   Filter by primary coding language
            -L, --limit int         Maximum number of repositories to list (default 30)
                --no-archived       Omit archived repositories
                --private           Show only private repositories
                --public            Show only public repositories
                --source            Show only non-forks
            -t, --template string   Format JSON output using a Go template
                --topic string      Filter by topic
    .link
        Dev.Nin\Invoke-GHCloneRepo
    .link
        Dev.Nin\_enumerateProperty_gh_repoList
    #>
    [Alias('Gh->RepoList')]
    [CmdletBinding()]
    param (
        [ALias('Owner')]
        [Parameter(Mandatory, Position = 0)]
        [argumentcompletions(
            'dfinke', 'EvotecIT', 'IISResetMe', 'IndentedAutomation',
            'Ninmonkey',
            'Jaykul', 'JustinGrote', 'SeeminglyScience', 'StartAutomating')]
        [string]$GitRepoOwner,

        # because it caches, set limit to 999
        [Parameter()]
        [uint]$Limit = 999, # 30,

        # see: gh repo list --help
        [Parameter(Position = 1)]
        [ValidateSet('Archived', 'NotArchived', 'Fork', 'Private', 'Public', 'Source')]
        [string[]]$Flags = @('Public', 'Source'),

        # basic sorting
        [Parameter()]
        [ArgumentCompletions('forkCount', 'stargazerCount', 'pushedAt')]
        [string]$SortBy = 'pushedAt',

        # jquery filter
        [Parameter()]
        [string]$JQQuery = @'
[.[] | {name, description, viewerHasStarred, languages, diskUsage, description, pushedAt, url, viewerSubscription, forkCount, stargazerCount, viewerHasStarred, viewerSubscription}]
'@,

        # [.[] | {name, description, viewerHasStarred, languages, diskUsage, description, pushedAt, url, viewerSubscription}]
        # [.[] | {url, name, diskUsage, description, pushedAt}]

        # reload cached
        [Alias('Force')]
        [Parameter()]
        [switch]$NoCache,

        # don't return objects?
        [Parameter()]
        [switch]$SkipAutoConvertFromJson,

        # show files, user may delete or use them.
        [Parameter()]
        [switch]$ShowCache,

        # return full json (skip jq)
        [Parameter()]
        [switch]$PassThru

    )
    begin {
        $DestBase = '~\.ninmonkey\cache\github'
        $Color = @{
            FGDimYellow    = [PoshCode.Pansies.RgbColor]'#937E5E'
            TermThemeFG    = [PoshCode.Pansies.RgbColor]'#EBB667'
            TermThemeError = [PoshCode.Pansies.RgbColor]'#943B43'
            FG             = [RgbColor]'#494943'
            # FGLight        = [rgbcolor]'#7C7C73'
            FGDim          = [rgbcolor]'#7C7C73'
            FGDim2         = [rgbcolor]'#A2A296'
        }
        if ($ShowCache) {
            Get-ChildItem $DestBase
            $DestBase | Join-String -DoubleQuote | Label 'root: '

        }
    }
    end {

        $cache = $script:__gh_cache

        if ($NoCache) {
            Write-Debug 'clearing cache'
            $cache.remove($GitRepoOwner)
        }
        $propList = 'url,pushedAt,parent,nameWithOwner,latestRelease,languages,labels,name,description,diskUsage,createdAt,viewerSubscription,viewerHasStarred'
        # $allRepo = gh repo list JustinGrote --source --json=$proplist --limit 999 | Set-Content 'api_response.json'
        [object[]]$GhArgs = @(
            'repo'
            'list'
            $GitRepoOwner
            '--limit', $Limit
        )

        $Flags | ForEach-Object {
            $mapping = switch ($_) {
                'Archived' {
                    '--archived'
                }
                'NotArchived' {
                    '--no-archived'
                }
                'Fork' {
                    '--fork'
                }
                'Private' {
                    '--private'
                }
                'Public' {
                    '--public'
                }
                'Source' {
                    '--source'
                }
                default {
                }
            }
            if ($mapping) {
                $GhArgs += $mapping
            }
        }
        $GhArgs += @(
            "--json=$propList"
        )


        $propList
        | Join-String -sep ', ' -SingleQuote | Write-Color $Color.FG
        $propList
        | Join-String -sep ', ' -SingleQuote | Write-Color $Color.FGDim
        | Join-String -op (
            'using API properties: ' | Write-Color $Color.FGDimYellow
        ) | wi

        $Limit | Join-String -op 'Limit: ' | wi
        $GhArgs | Join-String -sep ' ' -op 'gh: '
        | Write-Color $Color.TermThemeFG
        | wi
        $GhArgs | Join-String -sep ' ' -op 'gh: ' | Write-Debug


        if (! $cache.ContainsKey($GitRepoOwner)) {
            Write-Debug 'key not in cache, downloading...'
            $binResponse = & gh $GhArgs
            $cache[$GitRepoOwner] = $binResponse
            try {

                $Name = 'gh_RepoList-{0}.json' -f @($GitRepoOwner)
                $fullpath = Join-Path $DestBase $Name
                Write-Debug "Attempting to save cache to: '$FullPath'"
                Set-Content -Path $fullpath -Value $binResponse
                Write-Information "Response Cache save to: '$Fullpath'"
            } catch {
                Write-Error -ea continue -Exception $_ -m "Error writing cached value to '$fullpath'"
            }

        } else {
            Write-Debug 'reading cached values...'
        }

        if ($PassThru) {
            $cache[$GitRepoOwner]
            | jq
            return
        }

        if ($SkipAutoConvertFromJson) {
            $cache[$GitRepoOwner]
            | jq @($JQQuery)
        } else {
            $cache[$GitRepoOwner]
            | jq @($JQQuery)
            | ConvertFrom-Json #-Depth
            | Sort-Object $SortBy -Descending
        }




    }
}


if (! $experimentToExport) {
    # ...
}

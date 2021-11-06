# allows script to be ran alone, or, as module import

$experimentToExport.function += @(
    'Invoke-GHRepoList'
    '_gh_repoList_enumeratePropertyNames'
)
# $experimentToExport.alias += @(

# )
function _gh_repoList_enumeratePropertyNames {
    <#
    .synopsis
        get properties for 'gh repo list'
    #>
    param()
    $stdout = gh repo list --json *>&1 | Select-Object -Skip 1
    $stdout -replace '\s+', ''
}
# $props ??= _gh_repoList_enumeratePropertyNames

function _processGHRepoListRecord {
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

$__gh_cache ??= @{

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
        future: autocompleter will have these tooltips
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
    #>
    [CmdletBinding()]
    param (
        [ALias('Owner')]
        [Parameter(Mandatory, Position = 0)]
        [argumentcompletions(
            'dfinke', 'EvotecIT', 'IISResetMe', 'IndentedAutomation',
            'Ninmonkey',
            'Jaykul', 'JustinGrote', 'SeeminglyScience', 'StartAutomating')]
        [string]$GitRepoOwner,
            
        [Parameter()]
        [uint]$Limit = 30,
    
        # see: gh repo list --help
        [Parameter(Position = 1)]
        [ValidateSet('Archived', 'NotArchived', 'Fork', 'Private', 'Public', 'Source')]
        [string[]]$Flags = @('Public', 'Source'),

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

        # return full json (skip jq) 
        [Parameter()]
        [switch]$PassThru
        
    )
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
                'Archived' { '--archived' } 
                'NotArchived' { '--no-archived' } 
                'Fork' { '--fork' } 
                'Private' { '--private' } 
                'Public' { '--public' } 
                'Source' { '--source' }
                default {}
            }
            if ($mapping) {
                $GhArgs += $mapping
            }
        }        
        $GhArgs += @(
            "--json=$propList"
        )
        

        $GhArgs | Join-String -sep ' ' -op 'gh: ' | wi
        $GhArgs | Join-String -sep ' ' -op 'gh: ' | Write-Debug

        
        if (! $cache.ContainsKey($GitRepoOwner)) {
            Write-Debug 'key not in cache, downloading...'
            $binResponse = & gh $GhArgs
            $cache[$GitRepoOwner] = $binResponse
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
            | Sort-Object PushedAt -Descending   
        }
        
        
         

    }
}


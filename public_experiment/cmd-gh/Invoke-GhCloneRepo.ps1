$experimentToExport.function += @(
    'Invoke-GHCloneRepo'
)
$experimentToExport.alias += @(
    # 'GhRepoClone'
)


function Invoke-GHCloneRepo {
    <#
    .synopsis
        When you want to clone a list of repos from someone
    .description
        tags: gh, github, cli, clone, util
        Desc
    .link
        Dev.Nin\Invoke-GHRepoList
    .outputs

    #>
    
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # RootPath
        [Alias('Path')][Parameter()]
        [string]$BasePath = '.',

        # OwnerName
        [Parameter(Mandatory, Position = 0)]
        [string]$OwnerName,

        # RepoName
        [Parameter(Mandatory, Position = 1)]
        [string[]]$RepoName

    )

    begin {}
    process {
        $gh_args = @(
            'repo'
            'clone'
            "$OwnerName/$RepoName"
            "$OwnerName/$RepoName"
        )
        "gh '$path"
        Write-Host 'double check'
    }
    end {}
}

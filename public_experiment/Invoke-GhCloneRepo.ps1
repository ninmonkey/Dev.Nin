$experimentToExport.function += @(
    'Invoke-GHCloneRepo'
)
$experimentToExport.alias += @(
    'GhRepoClone'
)


function Invoke-GHCloneRepo {
    <#
    .synopsis
        When you want to clone a list of repos from someone
    .description
        Desc
    .outputs

    #>
    [Alias('GhRepoClone')]
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

#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-GHCloneRepo'
        'Invoke-GHCloneRepoWithSymbol'
    )
    $experimentToExport.alias += @(
        # 'GhRepoClone'
        'Gh->CloneRepo'
        'Gh->CloneRepoLabeled' # Invoke-GHCloneRepoWithSymbol
    )
}



function Invoke-GHCloneRepoWithSymbols {
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
    [Alias('Gh->CloneRepoLabeled')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # RootPath
        [Alias('Path')][Parameter()]
        [string]$BasePath = '.',

        # OwnerName
        [Alias('Prefix')]
        [Parameter(Mandatory, Position = 0)]
        [string]$Label,

        # OwnerName
        [Parameter(Mandatory, Position = 1)]
        [string]$OwnerName,

        # RepoName
        # #5 todo: auto complete using cached owner query
        [Parameter(Mandatory, Position = 2)]
        [string[]]$RepoName

    )

    begin {

        $str = 'enyancc/vscode-ext-color-highlight'
        $joinStr = '⁞'
        $owner, $repo = $str -split '/'
        $prefix = 'color'

        $dest = @($prefix; $owner; $repo) | Join-String -Separator $joinStr



    }
    process {
        $invokeCloneSplat = @{
            OwnerName         = 'a'
            BasePath          = 'a'
            Separator         = '|'
            RepoName          = 'a'
            InformationAction = 'Continue'
        }

        Invoke-GHCloneRepo @invokeCloneSplat




        $gh_args = @(
            'repo'
            'clone'
            "$OwnerName/$RepoName"
            "$OwnerName/$RepoName"
        )
        "gh '$path"
        Write-Host 'double check'
    }
    end {
    }
}

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
    [Alias('Gh->CloneRepo')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # RootPath
        [Alias('Path')][Parameter()]
        [string]$BasePath = '.',

        # OwnerName
        [Parameter(Mandatory, Position = 0)]
        [string]$OwnerName,

        # separator
        [Parameter()]
        [string]$Separator = '/',
        # '⁞' ,

        # RepoName
        [Parameter(Mandatory, Position = 1)]
        [string[]]$RepoName,

        # don't actually invoke
        [Alias('TestOnly')]
        [switch]$WhatIf = $true

    )

    begin {
        $dbg = [ordered]@{}
    }
    process {
        $dbg += @{
            BasePath = $BasePath
            Owner    = $Owner
            RepoName = $RepoName
        }
        $dbg | format-dict | Write-Debug
        # $dbg | out-default | write-debug
        $RepoName | ForEach-Object {
            $curRepoName = $_

            'todo:' | Write-Warning

            $gh_args = @(
                'repo'
                'clone'
                "${OwnerName}/${RepoName}"
                "${OwnerName}/${RepoName}"
            )
            Write-Host 'double check'
            'invoking....'
            "gh '$path"

            # 'color⁞mattbierner⁞vscode-color-info'
            $strQuerySrc = "${OwnerName}/${RepoName}"
            $strExport = "${basePath}/${OwnerName}/${RepoName}"
            $finalCommand_render = "repo clone $strQuerySrc $strExport"
            $GhArgs = @(
                'repo'
                'clone'
                $srcQuerySrc
                $strExport
            )# | JOin-string -sep ' '
            # final command
            $finalCommand | Join-String -sep ' ' -op 'gh ' | Write-Information

            $binGh = Get-NativeCommand -CommandName 'gh' -ea stop
            if (! $WhatIf) {
                & $binGh @GhArgs
            }

            # $finalCommand = "H $finalCommand | join-string -sep ' '
        }
    }
    end {
    }
}




if (! $experimentToExport) {
    # ...
}

#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-GHCloneRepo'
        'Invoke-GHCloneRepoWithSymbol'
        'Find-GhRepoName'
    )
    $experimentToExport.alias += @(
        # 'GhRepoClone'
        'Gh->CloneRepo'
        'Gh->CloneRepoLabeled' # Invoke-GHCloneRepoWithSymbol
        'Gh->RepoName' # 'Find-GhRepoName'
    )
}

function Find-GhRepoName {
    <#
        .synopsis
            get the name of an existing repo
        .notes
            future:
                - [ ] if 'Gh Repo View' fails
                    then 'reflog'? has the source/remote/local name
                - [ ] test on gists
                    that one displays name /w reflog
        .example
            🐒> GH->RepoName -Path '.'

                ninmonkey/Dev.Nin


            🐒> GH->RepoName -Path '.' -Prefix 'color'

                color⁞ninmonkey⁞Dev.Nin

    #>
    [Alias('GH->RepoName')]
    param(
        # Where to test?
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$Path,

        # use 'color' or whichever
        [parameter(Position = 1, ValueFromPipeline)]
        [string]$Prefix

        # future,may involve directory symbol names

        # # output formatting
        # [parameter(Position=1, ValueFromPipeline)]
        # [ValidateSet('Default', 'Prefix')]
        # [String]$OutputMode
    )
    process {
        $Path | Write-Debug
        $OriginalPath = Get-Item .
        try {
            $SearchRoot = Get-Item $Path -ea stop
            Push-Location $SearchRoot -StackName 'devNin.FindGh'

            $c ??= gh repo view --json='nameWithOwner,name,owner'
            $d = $c | From->Json -AsHashtable

            if ( [string]::IsNullOrWhiteSpace($Prefix) ) {
                return $d['nameWithOwner']
            }

            $newname = $d['nameWithOwner'] -replace '/', '⁞'
            $final = @( $prefix ; $newname ) | Join-String -sep '⁞'
            $final



            Pop-Location -StackName 'devNin.FindGh'
        } catch {
            Write-Error -Exception $_ -Message "'$Path'$ Failed, moving back to '$OriginalPath'"
            Set-Location -Path $OriginalPath

        }
    }
    end {
        Set-Location -Path $OriginalPath # rudundant is most cases, but since it's git path related
    }

}

function Invoke-GHCloneRepoWithSymbols {
    <#
    .synopsis
        When you want to clone a list of repos from someone
    .description
        tags: gh, github, cli, clone, util
        Desc

        #6 WIP:
    .link
        Dev.Nin\Invoke-GHRepoList
    .outputs

    #>
    [Alias('Gh->CloneRepoLabeled')]
    [CmdletBinding(
        # PositionalBinding = $false
    )]
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
        [switch]$WhatIf

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
            @('Final render: ' ; $finalCommand_render ) | Join-String | Write-Debug

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

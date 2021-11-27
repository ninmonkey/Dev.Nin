#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'dev.Invoke-JmGitCommand'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}



function dev.Invoke-JmGitCommand {
    <#
    .synopsis
        wrappers for git, mainly to remember what they are
    .description
        Written as a way to remember or document git usage

        limitations: current naive approach does not support for example:
            # works
            JGit Log maxcount 10 oneline

            # fails
            PS> JGit Log oneline maxcount 10

    .example
        PS>
        JGit branch remote asc
        JGit branch asc remote

        # show 4 expanded logs
        JGit log n 4

        # show 20 abbreviated logs
        JGit log n 20 oneline
    .notes
        future: Delegate autocomplete based on BaseCommand name

        future: Autocomplete parametersets relative the first BaseCommand would be ideal.

        For now, non-positional can toggle flags for all modes
        and BaseCommand switch should handle only the Positional-Args
    #>
    [alias(
        # 'JGit'
    )]
    param(
        # Required first mode
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet(
            'Branch', 'BranchFancy', 'Log', 'Fetch', 'Help', 'BranchByTime'
        )]
        [string]$BaseCommand = 'Help',

        # Positional Arg1 for $BaseCommand
        [Parameter(Position = 1)]
        [String]$Param1,

        # Positional Arg2 for $BaseCommand
        [Parameter(Position = 2)]
        [String]$Param2,

        # WhatIf: Skip running 'git'
        [Parameter()][switch]$WhatIf,

        # All remaning args, which are non-positional options for base command
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$RemainingArgs
    )

    if ($BaseCommand -like 'help') {
        $TutorialText = @'
- <https://support.atlassian.com/bitbucket-cloud/docs/branch-or-fork-your-repository/>
- <https://www.atlassian.com/git/tutorials/advanced-overview>
- <https://www.atlassian.com/git/tutorials/git-log>
- <https://www.atlassian.com/git/tutorials/git-prune>
- <https://www.atlassian.com/git/tutorials/merging-vs-rebasing>
- <https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting>
- <https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase>
- <https://www.atlassian.com/git/tutorials/undoing-changes>

'@
        $HelpText = @'
--format string docs:
    <https://git-scm.com/docs/git-for-each-ref>

Future args:
    git branch for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:relative)%09%(refname:short)' refs/heads -r
    git branch -r --format=' %(authordate:relative)%09%(refname:short)' --sort=committerdate

    git branch -r --format=' %(authordate:relative)%09%(refname:short)' --sort=committerdate
        | rg '$|ac|cust|job|addr|auto|complete'

    # local branch by date
    git branch --sort=committerdate

BranchFancy
    [, NonPositionalOptionArgs ]

Branch
    [ asc | desc ]  [, NonPositionalOptionArgs ]
    [ r | Remote ]  [, NonPositionalOptionArgs ]
    pretty | fancy

BranchByTime
    [ asc | desc ]  [, NonPositionalOptionArgs ]

Log
    [ NonPositionalOptionArgs ]
    [ line | oneline ]
    [ n | max-count ], <MaxCount> [, NonPositionalOptionArgs ]

Fetch
    []

Help
'@
        $TutorialText
        $HelpText

        return
    }
    $AllArgs = @($Param1, $Param2) + $RemainingArgs
    $AllArgs | Join-String -sep ', ' -SingleQuote -OutputPrefix 'JmGit Args = ' | Write-Debug

    # pre declarations
    $splatPrintGitArgs = @{
        Separator    = ', '
        SingleQuote  = $true
        OutputPrefix = 'git args:'
    }
    $strSortAsc = '--sort=committerdate'
    $strSortDesc = '--sort=-committerdate'

    $SortyByProp = @{
        AuthorIso        = "--sort='-authordate:iso8601'"
        CommiterDateAsc  = '--sort=committerdate'
        CommiterDateDesc = '--sort=-committerdate'
    }
    $FormatString = @{
        FuzzyShort = "--format=' %(authordate:relative)%09%(refname:short)'"
        FancyLong  = @'
--format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
'@


    }

    $FormatString = @{
        PrettyBranch = @'
--format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
'@
    }

    switch ($BaseCommand) {
        'BranchFancy' {
            $gitArgs = @(
                'for-each-ref'
                'refs/heads/'
                $FormatString.PrettyBranch
            )
            if (! $WhatIf ) {
                git @gitArgs
            }

            $gitArgs | Join-String @splatPrintGitArgs | Write-Debug
            break
        }
        'BranchByTime' {

            $gitArgs = @()
            $gitArgs += 'branch'

            if (Test-AnyItemInList @('r', 'remote') $AllArgs) {
                $gitArgs += '-r'
            }

            if (Test-AnyItemInList @('asc', 'ascending') $AllArgs) {
                $gitArgs += $strSortAsc
            }
            if (Test-AnyItemInList @('desc', 'descending') $AllArgs) {
                $gitArgs += $strSortAsc
            }
            if (! $WhatIf ) {
                git @gitArgs
            }

            $gitArgs | Join-String @splatPrintGitArgs | Write-Debug
            break
        }
        'Branch' {
            $gitArgs = @()

            if ($Param1 -in 'Remote', 'r') {
                $gitArgs += ('branch', '-r')
            } else {
                $gitArgs += ('branch')
            }

            if (Test-AnyItemInList @('fancy', 'pretty') $AllArgs) {
                $gitArgs += $FormatString.PrettyBranch
            }
            if (Test-AnyItemInList @('desc', 'descending') $AllArgs) {
                $gitArgs += $strSortAsc
            }

            if (! $WhatIf ) {
                git @gitArgs
            }

            $gitArgs | Join-String @splatPrintGitArgs | Write-Debug
            break
        }
        'Log' {
            # see: file:///C:/Program%20Files/Git/mingw64/share/doc/git-doc/git-log.html
            # one line arg
            # git log -n 3 --oneline
            $num = 5
            $gitArgs = @(
                'log'
            )
            if (Test-AnyItemInList @('line', 'oneline') $AllArgs) {
                $gitArgs += '--oneline'
            }
            # if (Test-AnyItemInList @('desc', 'descending') $AllArgs) {
            #     $gitArgs += $strSortAsc
            # }
            # if ($Param1 -in 'line', 'oneline') {
            #     $gitArgs += '--oneline'
            # }

            # Then next param dynamically, is count
            if ($Param1 -in ('n', 'max-count', '--max-count')) {
                # // this is never true
                $num = $Param2 -as 'int'
                $num ??= 5
            }
            $gitArgs += "--max-count=$num"


            if (! $WhatIf ) {
                git @gitArgs
            }
            $gitArgs | Join-String @splatPrintGitArgs | Write-Debug

            break
            # & git log --max-count=
        }
        # 'Fetch' {
        #     break
        # }
        default {
            Invoke-JmCommand -?
            # help JGit -example
            break
        }
    }
}


if (! $experimentToExport) {
    # ...

    JGit Branch r -WhatIf fancy desc r
    JGit Branch r fancy

}
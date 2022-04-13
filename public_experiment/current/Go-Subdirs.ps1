#Requires -Version 7
# wip dev,nin: todo:2022-03
# fun !
if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Dive-SubDirectory'
        '_Dive-Chain'
    )
    $experimentToExport.alias += @(
        'Go'
        'Dive->Dir' # 'Dive-SubDirectory'
        # 'Dive->DirectoryFancy' # 'Dive-SubDirectory_old'
    )
}



function _Dive-Chain {
    <#
    .synopsis
        interactive find directories below  you
    .notes

        todo:
        - [ ] current folder : description of children
        - [ ] params could include '[-2]' to go up 2 dirs
            - [ ] could be neat, start off with CWD
                >  DiveChain '.'
                then hit '[-2]
                    [-2] will preview folder names
        - [ ] preview files in dir, or relative time
        - [ ] dir dropdown selection
            sortby modified or name
        - [ ] preview that it's a empty dir, skip it

    #>
    param(
        [string]$Query,
        [int]$MaxDepth = 3

        # [string]$SortyBy = # [ 'Modified', 'Name' ]
    )
    [hashtable]$dbg = [ordered]@{
        MaxDepth    = $MaxDepth
        Query       = $Query
        InitialPath = Get-Location
    }
    $curDepth = 0
    $orginalRoot = Get-Location
    $SpecialStr = @{
        'reset' = '[reset]'
        'undo'  = '[undo] nyi state push pop'
        'quit'  = '[quit]'
    }

    while ($curDepth -le $MaxDepth) {
        $curDepth++

        $Destination = @(
            @(
                $SpecialStr.reset
                '[reset]'
                '[undo]'
                fd -t d -t d
            ) | fzf | Select-Object -First 1
        )

        $dbg['Destination'] = $Destination
        # if it only returns one value, then -eq check works
        switch ($Destination) {
            '[reset]' {
                'reset'
                return
            }
            '[undo]' {
                'undo'
                return
            }
            '[quit]' {
                'quit'
                $curDepth = $MaxDepth
                return
            }
        }

        # else it should be a file
        $query = $Destination | Get-Item




        # switch($Mode)

        Get-Location | ConvertTo-RelativePath -BasePath $orginalRoot
        | write-color 'orange'
        hr

        'from: {0} => {1}' -f @(
            Get-Location | Split-Path -Leaf
            | write-color 'gray60'

            $Destination | ConvertTo-RelativePath
            | write-color 'gray80'
        )


        # | Goto

    }
}
function Dive-SubDirectory {
    <#
    .synopsis
        quickly find dir, and choose which to goto
    .description
        sugar for commands like

            PS> fd -t d -d 3 bench | fzf -m | goto
    .notes
        todo:
            - [ ] --size <size>
            - [ ] --exclude <glob>
            - [ ] --preview=<command> ({})
            - [ ] --preview-window=<OPT>
            - [ ] --extension <e>
            - [ ] --changed-within <date|dir>
            - [ ] --changed-before <date|dir>
                maybe this is a 2nd command

            - [ ] --exec <cmd>
                run command on every result
            - [ ] --exec-batch <cmd>
                run command with all results at once

        #>
    [Alias(
        'Go',
        'Dive->Dir'
    )]
    [CmdletBinding()]
    param(

        # string passed to 'fd'
        [parameter(Mandatory , Position = 0, ValueFromRemainingArguments, ValueFromPipeline)]
        [string]$PathQuery,

        # for: '--max-depth <int>', set depth to 0 or null to disable depth testing
        [AllowNull()]
        [parameter()]
        [int]$MaxDepth = 3,

        [Parameter()][switch]$Help

    )
    if ($null -eq $MaxDepth) {
        $MaxDepth = 0
    }

    # exit early
    if ($Help) {
        & $binFd @('--help')
        hr
        & $binfzf @('--help')
        'https://github.com/junegunn/fzf'

        return
    }

    $binFd = Get-NativeCommand 'fd'
    $fzf = Get-NativeCommand 'fzf'

    [object[]]$fdArgs = @()
    [object[]]$fzfArgs = @()

    if ($maxDepth -gt 0) {
        $fdArgs += @(
            '--max-depth'
            $MaxDepth
        )
    }
    $fdArgs += @(
        '--type'
        'directory'

        $PathQuery
    )

    $fzfArgs += @(
        # '-m'
        # '--filter=STR'# -f ## filter, do not use  mode. Do not start interactive finder.
        # '--select-1' # -1 :: autoselect if1 only
        # '--exit-0' # -0 :: exit when none
        '--print-query'
    )

    @(
        $fdArgs | Join-String -sep ' ' -op 'ps> fd ' #| Write-Information
        $fzfArgs | Join-String -sep ' ' -op 'ps> fzf ' #| Write-Information
    ) | write-color cyan | Write-Information

    # // reference:
    #    PS> fd -t d -d 3 bench | fzf -m | goto

    & $binFd @fdArgs
    | & $binfzf @fzfArgs
    | Select-Object -First 1
    | Goto



    # fd -t d -d 3 bench | fzf -m | goto
}



function Dive-SubDirectory_old {
    <#
    .synopsis
        Stuff
    .description
        todo: #6 and #1
        more complicated / refactor


        special tab-complete syntax that's sugar for

            go data<tab>

        is sugar for

            go *data*<menuComplete>

        while not 1 match
            curPrefix += <substr from tab2>
            if curPrefix | one-or-none:
                then goto curPrefix
            else
                loop

    .notes
        related https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/register-argumentcompleter?view=powershell-7.3#example-3--register-a-custom-native-argument-completer

    #>
    [Alias(
        # 'Go',
        'Dive->DirectoryFancy'
    )]
    [CmdletBinding()]
    param(
        [parameter(Mandatory , Position = 0, ValueFromRemainingArguments, ValueFromPipeline)]
        [string]$PathQuery
    )

    begin {

        function _writeDirChange {
            param(
                $Destination
            )

            $ShortName = (Get-Location).path | Split-Path -Leaf

            '{0} -> {1}' -f @(
                $ShortName
                $Destination.Name
            )
            | Write-Color 'blue'
        }
    }
    process {
        # original logic
        #
        # if only one dir, use it

    }
    end {
        $toplevel = Get-ChildItem . -Directory
        $toplevel = $found_dir | ForEach-Object Name | Str csv ' ' | Write-Information
        # $found_dir = $toplevel | Where-Object { $_.Name -like $PathQuery }
        $found_dir = $toplevel | Where-Object { $_.Name -like "${PathQuery}*" }

        $found_dir | ForEach-Object Name | Str csv ' ' | Write-Information

        if ($found_dir.count -eq 1) {
            _writeDirChange -dest $found_dir.Name
            Push-Location $found_dir
            return
        }

        h1 'Matching path[s]'
        $foundDir | To->RelativePath
        return


        # if ($toplevel.count -eq 1) {

        #     Push-Location $toplevel
        # }
        # Push-Location | Select-Object
        <#
    # original:
    if ($toplevel.count -eq 1) {
        '{0} -> {1}' -f @(
            Get-Location | ForEach-Object Name
            $toplevel.Name
        )
        | write-color 'blue'

        Push-Location $toplevel
    }
    Push-Location | Select-Object
    #>
    }
}

if (! $experimentToExport) {
    # ...
    #Import-Module Dev.Nin -Force
    Push-Location 'G:\2021-github-downloads'
    Get-ChildItem . -dir

    go rust
    $expected = 'G:\2021-github-downloads\Rust\'
    Get-Location | Should -Be 'G:\2021-github-downloads\Rust'
}

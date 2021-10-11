function Dev-GetManPage {
    <#
    .synopsis
        shortcut to read and 'grep' man pages
    .description
        nice highlighting and finding of args, but needs a rewrite / clean pass
    .example
        # show entire man page, highlight flags
        PS> nman rg

    rg.example
        # equivalent
        PS> nman ls o,h,i
        PS> nman ls 'o', 'h', 'i'

    .example
        PS> # search for 2 flags, one as a regex
        PS> nman fzf 'm.*', 'layout'

    .example
        PS> nman code -FlagName 's', 'v'
        PS> nman pwsh -FlagName 'i', 'I'

        # find '-i', '-I' in 'fd'
        PS> nman fd -FlagName 'i', 'I'

        # find '-u' in 'bat'
        PS> man bat u

    .example
        🐒> nMan -CommandName code.cmd -FlagName r, g, d
        # (with highlights)

            Options
            -d --diff <file> <file>           Compare two files with each other.
            -a --add <folder>                 Add folder(s) to the last active window.
            -g --goto <file:line[:character]> Open a file at the path on the specified
                                                line and character position.
            -n --new-window                   Force to open a new window.
            -r --reuse-window                 Force to open a file or folder in an
                                                already opened window.
            -w --wait                         Wait for the files to be closed before
    .notes
        todo:

        - [ ] Add syntax highlighting or at least regex-based syntax highlighting of flags
        - [ ] if piping to LESS, pass search argument so user can hit 'next'/'prev' without doing anything
    #>
    [cmdletbinding(PositionalBinding = $false)]
    [Alias('Man', 'nMan')]
    param (
        # app name, hard coded for test
        [Parameter(Mandatory, Position = 0)]
        [Alias('Name')]
        # todo: replace with dynamic completer?
        # [ValidateSet()]
        [ArgumentCompleter( {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                $ValidValues = (
                    'fd', 'code', 'less', 'grep', 'git', 'gh', 'fzf', 'rg', 'python', 'pwsh', 'bat', 'powershell'
                )
                return $ValidValues -like "$WordToComplete*"
            }
        )]
        [string]$CommandName,

        # search for specific flag names
        [Parameter(Position = 1)]
        [Alias('Flag')]
        [string[]]$FlagName,



        # Skip cached local man page
        [Parameter()][switch]$NoCache
    )

    $AlwayColor = $true
    $Regex = @{
        BaseFlagRegex       = '[\s]*\-{1,2}[\w\-]*\b|$'

        # false positives like "dot-sourced"
        BaseFlagRegex_iter0 = '[\s]*\-{1,2}[\w\-]*\b|$'
        # BaseFlagRegex  = '\-{2}[\w\-]+'
        # HighlightRegex = '(\-{2}[\w\-]+)|$'
    }
    $Regex.ShortFlag_Part1 = '(?x-i)
        \s*\-{1,2}'
    $Regex.ShortFlag_Part2 = '\b'

    switch ($FlagName) {
        { $true } {
            $Inner = $FlagName | ForEach-Object {
                "($_)"
            } | Join-String -Separator '|'  -OutputPrefix '(' -OutputSuffix ')'

            $FullRegex = $regex.ShortFlag_Part1, $Inner, $Regex.ShortFlag_Part2 -join ''
            break
        }
        { $false } {
            $FullRegex = $regex.ShortFlag_Part1, $FlagName, $Regex.ShortFlag_Part2 -join ''
            break
        }
        default {
            throw "ShouldNeverReach: $FlagName"
        }
    }
    $Paths = @{
        'ModulePath' = (Get-Module Dev.Nin | ForEach-Object Path | Split-Path)
        'config'     = Get-Item -ea SilentlyContinue "$Env:USERPROFILE\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public\man\manpage.json"
        'manPage'    = Get-Item -ea SilentlyContinue "$Env:USERPROFILE\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public\man"
        # 'manPage'    = Get-Item -ea SilentlyContinue "$Env:USERPROFILE\2021\Powershell\My_Github\Dev.Nin\public\man\"
    }

    # Bug, it
    $manPage = Join-Path $Paths.manPage -ChildPath "$CommandName.man.txt"
    $cmdBin = Get-Command $CommandName -ea Continue -CommandType Application
    $cmdBin = Get-NativeCommand $CommandName -ea Stop
    $isSkipCache = (!(Test-Path $manPage -ea ignore)) -or (! $skipCache)
    <#
    #>
    # $metaDebug = @{
    #     'skipCache'         = $skipCache
    #     'regexFlag'         = $FullRegex
    #     'regexAllFlags'     = $regex.BaseFlagRegex
    #     'manPage'           = $manPage
    #     'cmdBin'            = $cmdBin
    #     'ParameterSetName'  = $PSCmdlet.ParameterSetName
    #     'PSBoundParameters' = $PSBoundParameters | Format-HashTable SingleLine
    # }

    # to refactor: so all conditions both work, but also use pipeline

    @(
        '$FlagName -eq null?:'
        [string]::IsNullOrWhiteSpace($FlagName)
    ) | Join-String -sep ' ' | Write-Debug

    "skip cache?: $isSkipCache" | Write-Debug

    if ( [string]::IsNullOrWhiteSpace($FlagName) ) {
        if ( $isSkipCache ) {

            & $cmdBin --help
            | rg "$($Regex.BaseFlagRegex)|`$"
            | rg -i "$($Regex.BaseFlagRegex)" --color=always
            return
        }
        Get-Content $manPage
        return
    }

    if ( $isSkipCache ) {
        # & $cmdBin --help  | rg -i $FullRegex -C 2
        & $cmdBin --help
        | rg -i $FullRegex -C 2 --color=always
        return
    }
    Get-Content $manPage | rg -i $FullRegex -C 2
    # $metaDebug | Format-HashTable -Title 'stuff' | Join-String -sep "`n" | Write-Debug
}

if ($false) {
    # Import-Module dev.nin -Force
    nMan rg -FlagName 'I'
    nMan fd  'i', 'I' -Debug
    nMan pwsh 'c', 'C', 'c.*'
    nMan pwsh -Debug | Select-Object -First 40
    # help curl
    # Get-Command help -All -ListImported | Format-List
    # nMan rg t, T
}

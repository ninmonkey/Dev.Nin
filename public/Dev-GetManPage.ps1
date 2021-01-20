function Dev-GetManPage {
    <#
    .synopsis
        shortcut to read and 'grep' man pages

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
    .notes
        - [ ] Add syntax highlighting or at least regex-based syntax highlighting of flags
        - [ ] if piping to LESS, pass search argument so user can hit 'next'/'prev' without doing anything
    #>
    [Alias('Man', 'nMan')]
    param (
        # app name, hard coded for test
        [Parameter(Mandatory, Position = 0)]
        [Alias('Name')]
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

    # function regexTemplate {
    #     [Parameter()]
    #     [object]$List

    # }

    switch ($FlagName) {
        { $true } {
            Write-Debug 'wip: Multi-flag filtering.
                use own coloring instead of ''grep'''
            # works for single flag
            # $Inner = $FlagName -join '|'

            # or condition user flags
            $Inner = $FlagName | ForEach-Object {
                "($_)"
            } | Join-String -Separator '|'  -OutputPrefix '(' -OutputSuffix ')'


            $FullRegex = $regex.ShortFlag_Part1, $Inner, $Regex.ShortFlag_Part2 -join ''
            # h1 'stuff'
            break
        }
        { $false } {
            # works for single flag
            $FullRegex = $regex.ShortFlag_Part1, $FlagName, $Regex.ShortFlag_Part2 -join ''
            # h1 'stuff' -fg green
            break
        }
        default { throw "ShouldNever: $FlagName" }
    }


    $Paths = @{
        'config'  = Get-Item -ea stop 'C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\Dev.Nin\public\man\manpage.json'
        'manPage' = Get-Item -ea stop 'C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\Dev.Nin\public\man\'
    }

    $manPage = Join-Path $Paths.manPage -ChildPath "$CommandName.man.txt"
    # $cmdBin = Get-Command $CommandName -ea Continue
    $cmdBin = Get-NativeCommand $CommandName -ea Stop

    $isSkipCache = (!(Test-Path $manPage)) -or (! $skipCache)

    $metaDebug = @{
        'skipCache'         = $skipCache
        'regexFlag'         = $FullRegex
        'regexAllFlags'     = $regex.BaseFlagRegex
        'manPage'           = $manPage
        'cmdBin'            = $cmdBin
        'ParameterSetName'  = $PSCmdlet.ParameterSetName
        'PSBoundParameters' = $PSBoundParameters | Format-HashTable SingleLine

    }


    # refactor so all conditions both work, but also use pipeline
    if ( [string]::IsNullOrWhiteSpace($FlagName) ) {
        $metaDebug['codePath0'] = 'null flag'
        if ( $isSkipCache ) {
            $metaDebug['codePath1'] = 'skipCache = $true'
            & $cmdBin --help
            | rg "$($Regex.BaseFlagRegex)|`$"
            | rg -i "$($Regex.BaseFlagRegex)" --color=always
            return
        }
        $metaDebug['codePath1'] = 'skipCache = $false'
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

    $metaDebug | Format-HashTable -Title 'stuff' | Join-String -sep "`n" | Write-Debug
}

if ($DevTesting) {
    # Import-Module dev.nin -Force
    nMan rg -FlagName 'I'
    nMan fd  'i', 'I' -Debug
    nMan pwsh 'c', 'C', 'c.*'
    nMan pwsh -Debug | Select-Object -First 40
}

# help curl
# Get-Command help -All -ListImported | Format-List
nMan rg t, T
Write-Warning 'next: enumerate so spacing between mult flags?'
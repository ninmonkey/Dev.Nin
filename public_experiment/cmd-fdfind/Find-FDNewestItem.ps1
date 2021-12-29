using namespace Management.Automation

$experimentToExport.function += @(
    'Find-FDNewestItem'
)
$experimentToExport.alias += @(
    'newestItem🔎', 'findNewest'
    # 'newestCode' # potential optional smart alias?
)
[hashtable]$__helpText = @{}


enum ColorWhenMode {
    Never
    Always
    Auto
}

enum FiletypeEnum {

    # -t, --type <filetype>...           Filter by type: file (f), directory (d), symlink (l),
    #                                    executable (x), empty (e), socket (s), pipe (p)
}

[object[]]$__helpText.FdFind = @'
    Regex Flavor: Rust:
        https://docs.rs/regex/1.0.0/regex/#syntax
    Docs:
        https://github.com/sharkdp/fd#how-to-use
        https://github.com/sharkdp/fd#using-fd-with-fzf
        https://github.com/junegunn/fzf#tips
'@
function Find-FDNewestItem {
    <#
    .synopsis
        Quickly find new items
    .description
       hardcoded use of 'fdfind' for a quick test
    tags:
        'Cli_Interactive🖐'
    .notes

        Iportant notes:


        $ENV:FZF_DEFAULT_COMMAND = 'fd --type f'
        fd --type f
        fd --type d
        fd --glob *.gif
        fd -d  2 --color=always | sort
        '@
                Docs: https://github.com/sharkdp/fd#how-to-use
                Regex's are Rust: https://docs.rs/regex/1.0.0/regex/#syntax

        --path-separator <separator>
        --full-path

    --- from profile
    - fd customization: <https://github.com/sharkdp/fd#integration-with-other-programs>
- fd-autocompleter reference: <https://github.com/sharkdp/fd/blob/master/contrib/completion/_fd>
- fzf keybindings <https://github.com/junegunn/fzf#key-bindings-for-command-line>


$Env:FZF_DEFAULT_COMMAND = 'fd --type file --follow --hidden --exclude .git'
$Env:FZF_DEFAULT_COMMAND = 'fd --type file --hidden --exclude .git --color=always'
$Env:FZF_DEFAULT_COMMAND = 'fd --type file --hidden --exclude .git --color=always'
$Env:FZF_DEFAULT_OPTS = '--ansi --no-height'
$Env:FZF_CTRL_T_COMMAND = "$Env:FZF_DEFAULT_COMMAND"





    working -X
        fd . -X ls -lhd --color=always

    working {}
        fd -e jpg -x convert {} {.}.png
        here, {} is a placeholder for the search result. {.}
    working ignore
        For example, we might want to search all hidden files and directories (-H) but exclude all matches from .git directories. We can use the -E (or --exclude) option for this. It takes an arbitrary glob pattern as an argument:

            PS> fd -H -E .git …
            PS> fd -E '*.bak' … #ignore filetype

    Note: fd also supports .ignore files that are used by other programs such as rg or
        config: %APPDATA%\fd\ignore | ~/.config/fd/ignore

To Implement Next:

    By default, fd only matches the filename of each file. However,
        using the --full-path or -p option, you can match against the full path.

For -x/--exec, you can control the number of parallel jobs by using the -j/--threads option. Use --threads=1 for serial execution.


    [2]
        -H, --hidden
            Include hidden directories and files in the
    [2]
        --max-results <num>
    [2]
        --max-results <num> | --
    [5]
        --<min|max>-depth <count <num>
    [5]
        --no-ignore
            Show search results from files and directories that would otherwise be ignored by '.gitignore', '.ignore',
    [4]
        --exclude <pattern> (glob only?)
    [3]
        --exec <cmd>
        --exec-batch <cmd>

    [1]
        --changed-within <date|dur>
            Filter results based on the file modification time. The argument can be provided as
            specific point in time (YYYY-MM-DD HH:MM:SS) or as a duration (10h, 1d, 35min).
            '--change-newer-than' can be used as an alias.
            Examples:
                --changed-within 2weeks
                --change-newer-than '2018-10-27 10:00:00'


    ...notes
        You can disable colors by setting:
            $Env:NO_COLOR
        Or the color enum


    .example
        # no args needed
        🐒> findNewest Code-Workspace💻
        🐒> findNewest Code-Workspace💻 -Color Never
    .example
        # only regex
        🐒> findNewest Code-Workspace💻 -regex 'd\+'
    .example
        # only path
        🐒> findNewest Code-Workspace💻 -Path ~
    .link
        code-venv
    .link
        Dev.Nin\Dev-InvokeFdFind
    .link
        Ninmonkey.Console\Get-NinCommand
    .outputs
          [string | None]

    #>
    [Alias('newestCode', 'newestItem🔎', 'findNewest')]
    [CmdletBinding(
        PositionalBinding = $false
        # SupportsPaging, # using --max;-results,
    )]
    param(
        # item types to find
        # See
        [Alias('Type')]
        [Parameter(
            Mandatory, Position = 0
        )]
        [ArgumentCompletions(
            'Code-Workspace💻', # code-workspace or just
            'Settings-Vs-Code', # not code-workspace, but still vs code config . maybe name: 'Code-Folder💻'
            'Image🎨', #
            'Code', # combination of pwsh, python, etc.
            'Pwsh',
            'Dir📁', # ps1, module, etc
            'Text📚', # many text types?
            'Log📚', # *.log
            'Power-BI📏', # pbix, pq, etc
            'nin.Bookmark.txt📚', # random
            'GitRepo💻' # parent of a '.git' dir
        )]
        [string[]]$ItemType,

        # max depth, $Null or 0 are interpreted as recurse all
        [Alias('MaxDepth')]
        [parameter(Position = 4)]
        [string]$Depth,

        # base path to use, optionally from pipeline, else cwd
        [Alias('Regex')]
        [parameter(Position = 1)]
        [string]$RegexPattern,

        # base path to use, optionally from pipeline, else cwd
        [Alias('--color')] # this is rude
        [parameter()]
        [ValidateSet('Always', 'Never', 'Auto')]
        # [ValidateSet( [ColorWhenMode]  )] # todo: Enum Not Working
        [string]$Color = 'Always',


        # base path to use, optionally from pipeline, else cwd
        [Alias('PSPath', 'Path')]
        [parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [string]$BasePath,

        # show urls or other misc notes
        [ALias('--help', 'Manpage')] # todo: future: Link or show markdown docs
        [Parameter()]
        [switch]$Help,

        # show urls or other misc notes
        # [ALias('')] # todo: future: Link or show markdown docs
        [Parameter()]
        [switch]$IgnoreHidden


        # [Parameter(
        #     Position = 1)]
        # [string[]]$SortByProp = 'Rgb'
        # [parameter]
    )

    begin {
        $binFd = Get-NativeCommand 'fd'
        Write-Warning 'next: '
    }
    process {
        if ($Help) {
            $__helpText.FdFind
            return
        }

        [string[]]$QueryExtension = @()
        if (! (Test-Path $BasePath) ) {
            $BasePath = '.'
        }
        $QueryRootDir = Get-Item $BasePath -ea stop

        $ItemType | ForEach-Object {
            # refactor/extract name to extension
            $curItemType = $_
            switch ($curItemType) {
                'Code-Workspace💻' {
                    $QueryExtension += @(
                        'code-workspace'
                    )
                }

                { $_ -match '(Power-BI📏)|Pbix' } {
                    $QueryExtension += @(
                        'pbix', 'pq'
                    )
                }

                'Image🎨' {
                    $QueryExtension += @(
                        'jpg', 'jpeg',
                        'gif', 'mp4',
                        'svg', 'svgz', # svg/inkscape
                        'xcf' # gimp
                    )
                }
                'Settings-Vs-Code' {
                    Write-Warning '"might need 2 queries, files of .json, or, folders of ".vscode"; and vscode snippet type'
                    $QueryExtension += @(
                        'json'
                    )
                }

                'Pwsh' {
                    $QueryExtension += @(
                        'ps1', 'ps1xml', 'psd1', 'psm1'
                    )
                }

                default {
                    Write-Error "Unhandled ItemType: '$curItem'"
                    return
                }
            }
        }
        #SPecial parameters
        if ($ItemType -contains 'nin.Bookmark.txt📚') {
            # filename pattern
            'nin\.Bookmark\.txt'
        }

        # $query | format-dict
        $fdArgs = @(
            if (! $IgnoreHidden) {
                '--hidden'
            }
            if ($Depth) {
                '--max-depth', $Depth
            }
            $QueryExtension | ForEach-Object {
                '--extension', $_
            }
            if (! $Env:NO_COLOR) {
                $ColorModeParam = switch ($Color) {
                    'Always' {
                        '--color=always'
                    }
                    'Never' {
                        '--color=never'
                    }
                    'Auto' {
                        '--color=auto'
                    }
                    default {
                        '--color=always'
                    }
                }
                $ColorModeParam
            } else {
                '--color=never'
            }

            $RegexPattern


            if ($BasePath) {
                if (!($RegexPattern)) {
                    # if none, but path does exist, 'fd' requires this "pattern"
                    '.'
                }
                '--'
                # $BasePath

                # $QueryRootDir
                $BasePath
                # | Join-String -DoubleQuote

            }
        )
        $dmeta = [ordered]@{
            Bin             = $BinFd
            QueryRoot       = $QueryRootDir
            FilterExtension = $QueryExtension
            NO_COLOR        = $null -ne $Env:NO_COLOR
            # FinalArgs       = $fdArgs #
            FinalArgs       = $fdArgs | Join-String -sep ' ' -op "$BinFd "
        }

        $dmeta | format-dict | Join-String -sep "`n" | Write-Information

        $binFd | Str prefix 'Bin: ' | Join-String | Write-Debug

        $fdArgs | Join-String -sep ' ' -op "$BinFd " | Write-Color 'blue' | Join-String -sep "`n" | Write-Information
        # 'invoke: ' | Write-Color orange | write-infomr
        & $binFd @fdArgs
        # @(

        #     'fd'
        #     # fd -d 5 -e code-workspace --color=always
        # )

    }


    end {
    }
}

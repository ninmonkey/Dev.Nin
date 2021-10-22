using namespace Management.Automation

$experimentToExport.function += @(
    'Find-FDNewestItem'
)
$experimentToExport.alias += @(
    'newestItem🔎', 'findNewest'
    # 'newestCode' # potential optional smart aliasese?
)

enum ColorWhenMode {
    Never
    Always
    Auto
}

function Find-FDNewestItem {
    <#
    .synopsis
        Quickly find new items
    .description
       hardcoded use of 'fdfind' for a quick test
    tags:
        'Cli_Interactive🖐'
    .notes

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



To Implement Next:

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
        [string]$BasePath

        # [Parameter(
        #     Position = 1)]
        # [string[]]$SortByProp = 'Rgb'

        # [parameter]
    )

    begin {
        $binFd = Get-NativeCommand 'fd'
    }
    process {
        [string[]]$QueryExtension = @()
        if (! (Test-Path $BasePath) ) {
            $BasePath = '.'
        }
        $QueryRootDir = Get-Item $BasePath  -ea stop

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

                }

                default {
                    Write-Error "Unhandled ItemType: '$curItem'"
                    return
                }
            }
        }

        # $query | format-dict
        $fdArgs = @(
            if ($true) {
                '-d', '5'
            }
            $QueryExtension | ForEach-Object {
                '-e', $_
            }
            if (! $Env:NO_COLOR) {
                $ColorModeParam = switch ($Color) {
                    'Always' { '--color=always' }
                    'Never' { '--color=never' }
                    'Auto' { '--color=auto' }
                    default {
                        '--color=always'
                    }
                }
                $ColorModeParam
            }
            else {
                '--color=never'
            }

            $RegexPattern


            if ($BasePath) {
                if (!($RegexPattern)) {
                    # if none, but path does exist, 'fd' requires this "pattern"
                    '.'
                }
                '--'

                $QueryRootDir
                | Join-String -DoubleQuote

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

        $dmeta | format-dict | Write-Information

        $binFd | Str prefix 'Bin: ' | Write-Debug

        $fdArgs | Join-String -sep ' ' -op "$BinFd " | Write-Color 'blue' | Write-Information
        # 'invoke: ' | Write-Color orange | write-infomr
        & $binFd @fdArgs
        # @(

        #     'fd'
        #     # fd -d 5 -e code-workspace --color=always
        # )

    }


    end {}
}

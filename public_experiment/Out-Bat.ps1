if ($experimentToExport) {
    
    $experimentToExport.function += @(
        'Out-BatHighlight'
        'Invoke-Batman'
    )
    $experimentToExport.alias += @(
        'Out-Bat'
        'Bat🐒'
        'Batman'
    )
}


function Out-BatHighlight {
    <#
    .synopsis
        When you want to clone a list of repos from someone
    .description
        tags: gh, github, cli, clone, util
        Desc
    .notes
        others:
            --diff
    .outputs

    #>
    
    [Alias('Out-Bat', 'Bat🐒')]
    [CmdletBinding(PositionalBinding = $false)]
    param(
        # inputstream
        # [Alias('Text')]
        # [Parameter(Mandatory)]
        # [string[]]$InputObject,

        # --file-name 
        [Alias('FileName')]
        [Parameter()][string]$Title,
        
        # file type
        [Parameter(Position = 0)]
        [string]$Language,
        
        # file type
        [Alias('Color')]
        [Parameter()]
        [ValidateSet('auto', 'never', 'always')]
        [string]$ColorWhen = 'always',
        
        # file type
        # Explicitly set the width of the terminal instead of determining it automatically. If
        # prefixed with '+' or '-', the value will be treated as an offset to the actual terminal
        # width. See also: '--wrap'
        [Parameter()]
        [string]$TerminalWidth,

        # file type
        [Parameter()]
        [ValidateSet('auto', 'never', 'character')]
        [string]$Style,

        # --paging <when>
        [Parameter()]
        [ValidateSet('auto', 'never', 'always')]
        [string]$Paging = 'auto',

        # file type
        [Parameter()]
        [ValidateSet('auto', 'never', 'character')]
        [string]$Wrap = 'auto' 
        # The '--terminal-width' option, can be used in addition to control the output width.

        <#
        more:
        --wrap <mode>
            Specify the text-wrapping mode (*auto*, never, character). The '--terminal-width' option
            can be used in addition to control the output width.

        --terminal-width <width>
            Explicitly set the width of the terminal instead of determining it automatically. If
            prefixed with '+' or '-', the value will be treated as an offset to the actual terminal
            width. See also: '--wrap'.
        #>

        # # RepoName
        # [Parameter(Mandatory, Position = 1)]
        # [string[]]$RepoName

    )

    begin {}
    # process {}

    # | bat -P -l json --color=always
    
    end {
        [object[]]$BatArgs = @(
            if ($Language) {
                '--language', $Language
            }
            if ($Title) {
                '--file-name', $Title
            }
            if ($ColorWhen) {
                '--decorations', $ColorWhen
            }
            if ($Wrap) {
                '--wrap', $Wrap
            }
            if ($Paging) {
                '--paging', $Paging
            }

            if ($TerminalWidth) {
                '--terminal-width', $TerminalWidth
            }
        )

        $BatArgs | Join-String -sep ' ' -op 'BatArgs: ' | wi 

        $Input
        | bat @BatArgs
    }
}


function Invoke-Batman {
    <#
        .synopsis
            man pages on windows
        .notes
            .
        .example   
            PS> man 'ls'
        #>
    # [outputtype( [string[]] )]
    [Alias('Batman')]
    [cmdletbinding()]
    param(
        # name of command
        [Alias('name', 'Command')]
        [ArgumentCompletions(
            'bat', 'choco', 'code-insiders.cmd', 'code.cmd', 'dotnet', 'fd', 'fzf',
            'py', 'pip', 'rg', 'ripgrep', 'fd', 'fdfind',
            'gh', 'git', 'jq', 'ls', 'node', 'npm', 'powershell', 'pwsh', 'python', 'tail',
            'wt'
        )]
        [parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [string]$CommandName
    
        # # extra options
        # [Parameter()][hashtable]$Options
    )
    begin {
        # [hashtable]$ColorType = Join-Hashtable $ColorType ($Options.ColorType ?? @{})       
        # [hashtable]$Config = @{
        #     AlignKeyValuePairs = $true
        #     Title              = 'Default'
        #     DisplayTypeName    = $true
        # }
        # $Config = Join-Hashtable $Config ($Options ?? @{})        
    }
    # process {}
    end {
        # $RemainingArgs = $Options

        
        $binCmd = Get-NativeCommand $CommandName -OneOrNone -ea Continue
        & $binCmd @('--help')
        | Out-BatHighlight -l man -Paging auto -infa Continue -Title $CommandName
        # | Out-BatHighlight -l man -Paging auto
    }
}

if (! $experimentToExport) {
    Batman fzf
}
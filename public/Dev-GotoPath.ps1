<# orignal CLI example

Goto $nin_paths.GithubDownloads
# fd --type d -d 5 'power*sh*' '.'
fd --type d -d 3 'gist' '.'
| Sort-Object
| fzf --filepath-word
# | fzf --multi=3
# --ansi
# --color: (dark|light|16|bw)

#>

function Dev-Get-Fd {
    param (
        # Max depth
        [Parameter()]
        [Alias('d')]
        [int]$Depth = 1
    )
}

# function Dev-SelectPath {

# }
function Out-Fzf {
    <#
    .synopsis
        uses commandline app 'fzf' similar to 'out-gridview'
    .description
        a simple multi-item selection for the console without the extra features of 'Out-ConsoleGridView'
    .notes
        selected items are returned **in-order** that they are selected in FZF
    .example
        PS>
    .notes
        .
    #>
    param (
        # show help
        [Parameter()][switch]$Help,

        # Multi select
        [Parameter()][switch]$MultiSelect,

        # Prompt title
        [Parameter()]
        [String]$PromptText,

        # main piped input
        # Docstring
        [Parameter(
            Mandatory, ValueFromPipeline)]
        [string[]]$InputText # future: support PSObjects with property '.Name' or ToString


        # future: Maximum selection: --multi[=max]
        # [Parameter()][int]$MaxMultiSelect
    )

    begin {
        if ($Help) {
            '<https://github.com/junegunn/fzf#tips> and ''fzf --help'''
            break
        }
        $binFzf = Get-Command 'fzf' -ErrorAction Stop

        $inputList = [list[string]]::New()

        $fzfArgs = @(
            '3'
            $MultiSelect ? '-m' : $null
            'b'
        )
    }
    process {

        # $fromPipe = 0..10
        # $finalCommand = {


        if ( ! [String]::IsNullOrWhiteSpace(  $PromptText ) ) {
            #or: $fzfArgs += ("--prompt='{0}'" -f $PromptText)
            $fzfArgs += ("--prompt={0}" -f $PromptText)
        }

        Label 'args' $fzfArgs | Write-Debug

        $fromPipe
        # | & $binFzf @fzfArgs

        # }

        # $selection = 0..10
        # | fzf
        # $selection

        # Write-Information

    }
    end {}
}

Goto $nin_paths.GithubDownloads
<# examples
Out-Fzf -Debug -Help
Out-Fzf -Debug -PromptText 'cat' -Help
# $x = Out-Fzf
#>

Get-ChildItem | Select-Object -First 3
| Out-Fzf -Debug

function Dev-GotoPath {
    <#
    .synopsis
        search for stuff, then FZF, then goto single path?
    #>
}
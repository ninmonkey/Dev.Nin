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

function Dev-GotoPath {
    <#
    .synopsis
        search for stuff, then FZF, then goto single path?
    #>
}
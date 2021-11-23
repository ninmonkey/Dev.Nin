$helpText = @'
$ENV:FZF_DEFAULT_COMMAND = 'fd --type f'


    fd --type f
    fd --type d
    fd --glob *.gif
    fd -d  2 --color=always | sort
'@

function Dev-InvokeFdFind {
    <#
    .synopsis
        wrapper to find files /w fdfind : dodo replace with the other root level wrapper
    .notes
        Docs: https://github.com/sharkdp/fd#how-to-use
        Regex's are Rust: https://docs.rs/regex/1.0.0/regex/#syntax

    .link
        Dev.Nin\Find-FDNewestItem
    .link
        Dev.Nin\Peek-NewestItem
    .link
        Dev.Nin\Find-DevFdFind
    .link
        Dev.Nin\Invoke-FdFind

    #>
    [Alias('dev-Fd', 'LsFd')]
    param(
        # Docstring
        [Parameter(Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # Help
        [Parameter()][switch]$Help
    )

    if ($Help) {
        nMan fd
        Hr 2

        $HelpText
        return
    }


    $binFd = Get-NativeCommand 'fd' -ea Stop

    $argList = @(
        '--type f'
    )

    & $binFd @argList

    $argList | Join-String -sep ' ' -SingleQuote -OutputPrefix '> fd '
    | Write-Debug

}

if ($TestDebugLocal) {
    Dev-InvokeFdFind -Debug -Help
}

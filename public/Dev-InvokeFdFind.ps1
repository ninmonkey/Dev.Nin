$helpText = @'
$ENV:FZF_DEFAULT_COMMAND = 'fd --type f'


    fd --type f
    fd --type d

'@

function Dev-InvokeFdFind {
    <#
    .link
        Find-DevFdFind
    .link
        Invoke-FdFind

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

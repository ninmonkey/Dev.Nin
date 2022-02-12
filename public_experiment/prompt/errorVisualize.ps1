function _prompt.errVisual {
    <#
    .synopsis
        micro script of pwsh
    .example
        PS> # with errors

            ................
            16 >
    #>
    @(
        $numErr = $Error.Count
        '.' * $numErr
        "`n${NumErr} > "

    )-join ' '
}

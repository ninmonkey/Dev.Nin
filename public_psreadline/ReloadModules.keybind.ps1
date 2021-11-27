#Requires -Version 7

throw 'never reaches here'

if ( $PSRL_experimentToExport ) {

    $PSRL_experimentToExport.PSReadLineKeyHandler += @(
        # {
        Set-PSReadLineKeyHandler -Description 'Reload NinModules' -Chord Ctrl+r -ScriptBlock {
            [console]::WriteLine('Reloading...')
            $status = 'Ninmonkey.Console', 'Dev.Nin' | Join-String -sep ', ' -SingleQuote -sep-op 'Modules: '
            Import-Module Ninmonkey.Console, Dev.Nin -Force
            [console]::WriteLine("`n`n$status`n`n")
            [console]::WriteLine('hi world')
            [console]::WriteLine('hi world')
            [console]::WriteLine('hi world')

        }
        # }
    )
}

if (! $PSRL_experimentToExport) {
    # ...
}
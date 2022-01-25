#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'F'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

Start-Process 'pwsh' -Verb RunAs -args @(
    '-NoProfile', '-C', {
        $logs ??= Get-ChildItem C:\Windows\Temp *.evtx


        $logs.count | Join-String -op 'log.count: '
        $logs | Measure-Object -Sum -Property Length
        | Join-String {
            ($_.Sum / 1MB).tostring('n')
        } -os 'MB' -op 'from c:\windows\temp *.evtx = '

        'cleaning...'
        $logs | Remove-Item


        Start-Sleep 1
        $logs = Get-ChildItem C:\Windows\Temp *.evtx

        $logs.count | Join-String -op 'log.count: '
        $logs | Measure-Object -Sum -Property Length
        | Join-String {
            ($_.Sum / 1MB).tostring('n')
        } -os 'MB' -op 'from c:\windows\temp *.evtx = '
        'Done. Sleeping 5...'
        Start-Sleep 5
    }
)



if (! $experimentToExport) {
    # ...
}

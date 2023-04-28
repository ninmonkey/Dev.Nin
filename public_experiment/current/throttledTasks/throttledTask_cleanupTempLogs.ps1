#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(

    )
    $experimentToExport.alias += @(

    )
}

if ($script:___throttleTaskList) {

    $SBTask = {
        Start-Process 'pwsh' -Verb RunAs -args @(
            '-NoProfile', '-C', {
                $logs = Get-ChildItem C:\Windows\Temp *.evtx


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
    }

    $newTask = [ThrottledTaskInfo]::new(
        'Remove Temp Logs',
        'Remove extra *.evtx logs from c:\windows\temp',
        '5h',
        $SBTask)
    $script:___throttleTaskList.add( $NewTask )
}



if (! $experimentToExport) {
    # ...
}

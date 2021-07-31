
function __find_worst_ping {


    $logPath ??= Start-LogTestNet -GetLogPath
    $csv = Import-Csv  $logPath
    $csv
    | Where-Object { [int]$_.Latency -gt 100 }
    | Format-Table -AutoSize

    @'
    next:
        - [ ] read more than one log file

        - [ ] convert this to fuzzy dates, which I need for Ls
        [datetime]'2021-07-24T00:08:56.3482744-05:00'
        - [ ] then GroupBy(FuzzyDate)

    - [] PowerQuery function: Fuzzy Time
        - [ ] then GroupBy(FuzzyDate)1



'@
}
# __find_worst_ping

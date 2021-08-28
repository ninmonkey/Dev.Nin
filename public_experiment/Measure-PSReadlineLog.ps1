$experimentToExport.function += 'Measure-PSReadlineLog'

function Measure-PSReadlineLog {
    # Counts lines vs distinct line count of history files
    param()
    $logs = Get-ChildItem -Recurse "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine" -Filter '*_history.txt'
    $lines ??= Get-Content $logs
    $logs
    Hr
    $lines
    | Measure-Object -Line -Word
    | Join-String -sep ' ' {
        'Lines: {0:n0} -  Words: {1:n0}' -f @(
            $_.Lines; $_.Words
        ) }
    $lines
    | Sort-Object -Unique
    | Measure-Object -Line -Word
    | Join-String -sep ' ' {
        'Unique Lines: {0:n0} -  (maybe unique?) Words: {1:n0}' -f @(
            $_.Lines; $_.Words
        ) }
    $lines | Group-Object | Sort-Object Count -Descending -Top 10 | Format-Table -AutoSize
    Hr
    $Logs | Join-String -op "From logs: " -sep ', ' -single

}


# eaiser to manage and filter, especially a dynamic set, in one place
[hashtable]$experimentToExport = @{
    'function' = @()
    'alias'    = @()
    'cmdlet'   = @()
    'variable' = @()
    # 'formatData' = @()
}

# Don't run tests
Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot)
| Where-Object { $_.Name -ne 'main_import_experimental.ps1' }
| Where-Object { $_.Name -notmatch '\.tests\.ps1$' }
| ForEach-Object -ea stop {
    Write-Debug "Import: $_"
    . $_
    Write-Warning "import '$_' "
}

$experimentToExport | Join-String -op 'ExperimentToExport' | Write-Debug
if ($experimentToExport['function']) {
    Export-ModuleMember -Function $experimentToExport['function']
}
if ($experimentToExport['alias']) {
    Export-ModuleMember -Alias $experimentToExport['alias']
}
if ($experimentToExport['cmdlet']) {
    Export-ModuleMember -Cmdlet $experimentToExport['cmdlet']
}
if ($experimentToExport['variable']) {
    Export-ModuleMember -Variable $experimentToExport['variable']
}

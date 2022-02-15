

# eaiser to manage and filter, especially a dynamic set, in one place
[hashtable]$script:stableToExport = @{
    'function' = @()
    'alias'    = @()
    'cmdlet'   = @()
    'variable' = @()
    'meta'     = @()
    # 'formatData' = @()
}

# & {

# Don't dot tests, don't call self.
Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot)
| Where-Object { $_.Name -match '\.ps1$' }
| Where-Object { $_.Name -ne '__init__.ps1' }
| Where-Object { $_.Name -notmatch '\.tests\.ps1$' }
| ForEach-Object {
    . $_
}

# $stableToExport.Function | Join-String -op 'stableToExport' | Write-Debug
# $stableToExport | Join-String -op 'stableToExport' | Write-Debug

if ($stableToExport['function']) {
    Export-ModuleMember -Function $stableToExport['function']
}
if ($stableToExport['alias']) {
    Export-ModuleMember -Alias $stableToExport['alias']
}
if ($stableToExport['cmdlet']) {
    Export-ModuleMember -Cmdlet $stableToExport['cmdlet']
}
if ($stableToExport['variable']) {
    Export-ModuleMember -Variable $stableToExport['variable']
}

# $meta | Write-Information

# }
#

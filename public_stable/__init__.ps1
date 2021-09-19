

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
| Where-Object { $_.Name -ne '__init__.ps1' }
| Where-Object {
    # are these safe? or will it alter where-object?
    # Write-Debug "removing test: '$($_.Name)'"
    $_.Name -notmatch '\.tests\.ps1$'
}
| ForEach-Object {
    # are these safe? or will it alter where-object?
    # Write-Debug "[dev.nin] importing experiment '$($_.Name)'"
    . $_
}

$stableToExport | Join-String -op 'stableToExport' | Write-Debug

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

$meta | Write-Information

# }
#

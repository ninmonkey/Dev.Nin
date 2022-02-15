using namespace system.collections.generic

Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot)
| Where-Object { $_.Name -match '\.ps1$' }
| Where-Object { $_.Name -ne '__init__.ps1' }
| Where-Object { $_.Name -notmatch '\.tests\.ps1$' }
| Sort-Object { $_.Name -eq 'GetSet-ModuleMetadata.ps1' } -Descending
| ForEach-Object {
    . $_
}

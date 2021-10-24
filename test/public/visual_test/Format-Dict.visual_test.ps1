Import-Module dev.nin -Force
hr
'hi'
$ErrorActionPreference = 'continue'
Get-ChildItem env: | FOrmat-DIct

$h = @{ species = 'cat' ; lives = 9 }
$h | Format-Dict

$o = [pscustomobject]$h
$o | Format-Dict


'todo: other $options like
- [ ] darken \x2400-\x2500 to gray30
    - [ ] after, then preserve newline symbols, after -join
- [ ] align columns
- [ ] force truncation, force single line merge
- [ ] enumerate recursive for values?
' | Write-Warning
$ErrorActionPreference = 'Stop'
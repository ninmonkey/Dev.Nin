# Import-Module dev.nin -Force -wa ignore | Out-Null
hr

'see also: ./test/public/visual_test/Find-Property.visual_test.ps1'



'hi'
$ErrorActionPreference = 'continue'
Get-ChildItem env: | FOrmat-DIct -ea break

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

hr 2
'Part1: '

@(
 (Get-Item .)
    @{'a' = 3; z = 4 }
    'hi world'
    [pscustomobject] @{'a' = 3; z = 4 }
) | Format-Dict -infa continue

hr 2
'Part2: '




hr 20


Get-ChildItem env: | f 3 | Format-Dict

$h = @{ species = 'cat' ; lives = 9 }
$h | Format-Dict

$o = [pscustomobject]$h
$o | Format-Dict

# Get-ChildItem env: | f 3
hr 10





@(
    Get-Process | f 2
    Get-Item .

    $h = @{
        species = 'cat' ; lives = 9
    }
    $h

    $h = Join-Hashtable $h @{bar = 0..9 }

    $o = [pscustomobject]$h
    $o

    Get-Date
) | Format-Dict
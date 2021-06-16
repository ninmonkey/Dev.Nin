throw 'See Ninmonkey.Console\Find-NativeCommand'

h1 'then'

Get-Command -Type Application | ForEach-Object Source | Group-Object { $_ | Split-Path } | Sort-Object Count

h1 'then'

Get-Command -Type Application | ForEach-Object Source
| Group-Object { $_ | Split-Path } | Sort-Object Count
| Where-Object { $_.Name -match 'windows' }
| Format-Table -AutoSize

h1 'and'

$findAll ??= Get-Command -Type Application | ForEach-Object Source
| ForEach-Object {
    Get-Item -ea stop -LiteralPath $_
}

$afterFilterSys = $findAll
$afterFilterSys | Where-Object { $_.FullName -match 'windows|system32' }
| Select-Object -First 3
# $afterFilterSys | select -First 5
#| Group { $_ | Split-Path } | sort Count
#| ft -AutoSize

$afterFilterSys | Where-Object { $_.FullName -match 'windows|system32' }
| Measure-Object

$findAll ??= Get-Command -Type Application | ForEach-Object Source | ForEach-Object { Get-Item -ea stop -LiteralPath $_ }

$afterFilterSys = $findAll
$afterFilterSys | Where-Object { $_.FullName -match 'windows|system32' }
| Select-Object -First 3

$findAll ??= Get-Command -Type Application | ForEach-Object Source | ForEach-Object { Get-Item -ea stop -LiteralPath $_ }

$afterFilterSys = $findAll
$afterFilterSys | Where-Object { $_.FullName -match 'windows|system32' }
| Select-Object -First 3


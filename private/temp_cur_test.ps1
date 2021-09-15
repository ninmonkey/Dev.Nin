# Import-Module dev.nin, ninmonkey.console -Force 3>$NULL
Import-Module dev.nin -Force 3>$NULL
'hi world'
# 'rgbcolor' | New-TypeInfo

# $samples3 | _formatErrorSummary | Select-Object -First 3
$samples3 ??= $error
$samples3 | _formatErrorSummary | Select-Object -First 3

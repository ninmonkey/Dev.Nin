<#

#>

# input:

$Sample = @{
    'Line' = 'Microsoft.PowerShell.Core\FileSystem::C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\Ninmonkey.Console'
}

$Config = @{
    MaxLength     = 40
    IncludeFirstN = 5
    IncludeLastN  = 3
}


function Format-SummarizeString {
    [Alias('Abbr', 'AbbrString')]
    param(
        # Docstring
        [Parameter(Mandatory, Position = 0)]
        [object]$ParameterName
    )
}

# & {
H1 'FakePester'
$sample = 'Microsoft.PowerShell.Core\FileSystem::C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\Ninmonkey.Console'
$SampleLength = $sample.Length
$Padding = 5
Label Sample $Sample
Label Length $SampleLength
$expected = 'Micro
    soft.PowerShell.Core\FileSystem::C:\Users\cppmo_000\Documents\2020\powershell\MyModules_Github\Ninmonkey.Co
    nsole'

$prefixString = $sample[0..$Padding] | Join-String -sep ''
$suffixStartIndex = $SampleLength - $Padding
$suffixString = $sample[$suffixStartIndex..$SampleLength] | Join-String -sep ''

$remainingStart = $Padding + 1
$remaingEnd = $SampleLength - $Padding - 1
$remainingString = $Sample[$remainingStart..$remaingEnd] | Join-String -sep ''

$remainingCharLength = $remainingString.length



H1 'rebuild original'
$testFinalAbbrString = $prefixString, $remainingString, $suffixString -join ''
$testFinalAbbrString | Should -be $sample -Because 'That is a rejoin to the original'

$beforeInner = $prefixString, '…', $suffixString | Join-String -sep ''
$lengthToRemove = $remainingCharLength - ($prefixString.Length) - 3


$naiveTruncText = $prefixString.Length - $lengthToRemove


$meta = [ordered]@{
    'suffixStartIndex'    = $suffixStartIndex
    'suffixString'        = $suffixString
    'remainingStart'      = $remainingStart
    'remaingEnd'          = $remaingEnd
    'prefixList'          = $prefixString
    'remainingSample'     = $remainingString
    'remainingCharLength' = $remainingCharLength
    'finalAbbrString'     = $finalAbbrString
    'beforeInner'         = $beforeInner
}
$meta | Format-HashTable

throw @'
works until here: > $beforeInner = $prefixString, '…', $suffixString | Join-String -sep ''
    works until:
'@
H1 'final'
$finalAbbrString
# }
Write-Warning 'refactor substrto [Rune] enumerate, else [string] functions'
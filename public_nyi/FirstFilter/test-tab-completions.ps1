Hr -fg orange
<#
'go'

- PSIC continues suggesting more -MemberTypes
Diverges in 2 ways

`,<mc>`
PSIC this continues
Editor has nothing

`,<spaces><mc>`
PSIC continues
Editor suggests filenames

#>
. 'C:\Users\cppmo_000\SkyDrive\Documents\2021\PowerShell\My_Github\Dev.Nin\public_experiment\completer\Invoke-TabCompletionColumnResults.ps1'
$Samples = @(
    'Get-Item . | Find-Member -MemberType All,',
    'Get-Item . | Find-Member -MemberType All, '
)

$results = @{}

$results.NoSpace = Invoke-TestTabExpansionResults -InputScript $Samples[0]
$results.WithSpace = Invoke-TestTabExpansionResults -InputScript $Samples[1]

$results
# gi . | Find-Member -MemberType All,Custom,

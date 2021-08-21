$experimentToExport.function += 'Invoke-CodeFzf'
$experimentToExport.alias += 'CodeFzf', 'DiveFzf'

function Invoke-CodeFzf {
    [alias('CodeFzf', 'DiveFzf')]
    [cmdletbinding(PositionalBinding = $false)]
    param(
        # Docstring
        [Parameter()]
        [string]$Query
    )

    Write-Debug "codeFzf: Starting in: $(Get-Item .)"

    code (Get-Item (fzf))
}

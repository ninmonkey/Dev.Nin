

# $experimentToExport.function += 'Test-AllTrue'
# $experimentToExport.alias += 'AllTrue'
function Search-PropertyRegex {
    <#
    .synopsis

    .description
        .
    .example
        PS>
    .notes
        .
    #>
    param (
        # Docstring
        [Parameter(Mandatory, Position = 0)]
        [object]$ParameterName
    )
    begin {}
    process {}
    end {}
}

# Example on Commandline
@'
# Diff Properties, Diff Regex
$allpackages | Where-Object {
    $_.PackageFullName -match 'windowsterminal|wt' -or
    $_.InstallLocation -match 'WindowsApps\\Microsoft\.WindowsTerm'
}
'@

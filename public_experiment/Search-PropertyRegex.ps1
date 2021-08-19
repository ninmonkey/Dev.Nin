$experimentToExport.function += 'Search-PropertyRegex'
$experimentToExport.alias += 'WhereProperty'

function Search-PropertyRegex {
    <#
    .synopsis

    .description
        .
    .example
        PS>
# Example on Commandline
@'
# Diff Properties, Diff Regex
$allpackages | Where-Object {
    $_.PackageFullName -match 'windowsterminal|wt' -or
    $_.InstallLocation -match 'WindowsApps\\Microsoft\.WindowsTerm'
}
'@
    .notes
        .
    #>
    [Alias('WhereProperty')]
    [cmdletbinding(PositionalBinding = $false)]
    param (
        # Docstring
        [Parameter(Mandatory, Position = 0)]
        [string]$ParameterName
    )
    begin {
        @'
example:

    # Diff Properties, Diff Regex
    $allpackages | Where-Object {
        $_.PackageFullName -match 'windowsterminal|wt' -or
        $_.InstallLocation -match 'WindowsApps\\Microsoft\.WindowsTerm'
    }
'@

    }
    process {

    }
    end {}
}

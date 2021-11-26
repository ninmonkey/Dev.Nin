#Requires -Version 7

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Invoke-CleanupPSDefaultParameterValues'
    )
    $experimentToExport.alias += @(
        # 'A'
    )
}

function Invoke-CleanupPSDefaultParameterValues {
    <#
    .synopsis
        [WIP] . test if all values exist
    .description
        - think PScriptAnalzyer rules but simpler
        - future: maybe convert to a real rule ? I wasn't sure when it'd invoke
       .
    .example
          .
    .outputs
          [hashtable]

    #>
    [CmdletBinding(PositionalBinding = $false)]
    param(

    )

    begin {
    }

    process {
        $baseDict = ( $PSDefaultParameterValues ?? $global:PSDefaultParameterValues)
        $results = [ordered]@{}
        $results['BaseDict'] = $BaseDict
        $results['Commands'] = @()
        $results['Warning_Commands']
        $results['Warning_Parameters'] = @{ NYI = 'PSScriptAnalyzer rule that params are actually valid' }
        $results['Warning_ParameterNames'] = @{ NYI = 'PSScriptAnalyzer rule that param Names are actually valid' }

        [pscustomobject]$results
    }
    end {
        Write-Warning 'Function is WIP'
    }
}

function Get-CleanupCommand {
    <#
    .synopsis
        - list of cleanup actions
    #>
    [cmdletbinding()]
    param()

    @(
        'Invoke-CleanupPSDefaultParameterValues'
    ) | Get-Command

    h1 'NYI'
    @'
    - [ ] Invoke-CleanupMissingNamespaceImports
        nyi: search for files with "[list" but no import namespace

    - [ ]  Cleanup-DeprecatedSettings
        check whether  Set-ItResult() is passed "pending|inconclusive" deprecated args
            https://pester.dev/docs/commands/Set-ItResult#-pending
'@

}

if (! $experimentToExport) {
    # ...
    h1 'raw baselist'
    $PSDefaultParameterValues

    $report = Invoke-CleanupPSDefaultParameterValues
    h1 'report'
    $report | Format-List

    # todo: maybe I should return different types when iterating? what if modifying .value ?
    $report | Iter->Prop | ForEach-Object {
        h1 $_.Name

        $_.Value | Format-List

    }

}
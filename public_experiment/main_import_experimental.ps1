
function Write-NinLog {
    <#
    .synopsis
        temp logging, easy
    .description
        temp logging, easy
    .example
        PS>
    .notes
        .
    #>
    param (

    )
    begin {}
    process {}
    end {}
}

# eaiser to manage and filter, especially a dynamic set, in one place
[hashtable]$script:experimentToExport = @{
    'function' = @()
    'alias'    = @()
    'cmdlet'   = @()
    'variable' = @()
    'meta'     = @()
    # 'formatData' = @()
}

& {

    # Don't dot tests, don't call self.
    Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot)
    | Where-Object { $_.Name -ne 'main_import_experimental.ps1' }
    | Where-Object {
        # are these safe? or will it alter where-object?
        # Write-Debug "removing test: '$($_.Name)'"
        $_.Name -notmatch '\.tests\.ps1$'
    }
    | ForEach-Object {
        # are these safe? or will it alter where-object?
        # Write-Debug "[dev.nin] importing experiment '$($_.Name)'"
        . $_
    }

    $experimentToExport | Join-String -op 'ExperimentToExport' | Write-Debug

    if ($experimentToExport['function']) {
        Export-ModuleMember -Function $experimentToExport['function']
    }
    if ($experimentToExport['alias']) {
        Export-ModuleMember -Alias $experimentToExport['alias']
    }
    if ($experimentToExport['cmdlet']) {
        Export-ModuleMember -Cmdlet $experimentToExport['cmdlet']
    }
    if ($experimentToExport['variable']) {
        Export-ModuleMember -Variable $experimentToExport['variable']
    }

    $meta | Write-Information

}

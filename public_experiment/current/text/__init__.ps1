# throw "Should Be '$PSCommandPath'"

[hashtable]$script:experimentToExport ??= @{
    'function'                   = @()
    'alias'                      = @()
    'cmdlet'                     = @()
    'variable'                   = @()
    'meta'                       = @()
    'update_typeDataScriptBlock' = @()
    'experimentFuncMetadata'     = @()
    # 'formatData' = @()
}
# $ErrorActionPreference = 'break'
$ErrorActionPreference = 'stop'
# & {

try {
    $ignoreNamesLiteral = @(
        '.visual_tests.ps1', '.Interactive.ps1',
        '__init__.ps1'
    )
    | ForEach-Object {
        [regex]::escape($_)
    }
    # Don't dot tests, don't call self.
    $filteredFiles = Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot) -Filter '*.ps1'
    | Where-Object { $_.Name -ne '__init__.ps1' }
    | Where-Object {
        $curFile = $_
        $match_tests = $ignoreNamesLiteral | ForEach-Object {
            $pattern = $_
            $curFile -match $pattern
        }
        -not [bool](Test-Any $match_tests)
    }
    | Where-Object {
        # are these safe? or will it alter where-object?
        # Write-Debug "removing test: '$($_.Name)'"
        $_.Name -notmatch '\.tests\.ps1$'
    }
    $filteredFiles
    | Join-String -sep ', ' -SingleQuote FullName -op 'Filtered Imports: '
    | Write-Verbose

    $sortedFiles = $filteredFiles | Sort-Object { @('Write-TextColor') -contains $_.BaseName } -Descending

    $sortedFiles | Join-String -sep ', ' -SingleQuote FullName -op 'Sorted Imports: '
    | Write-Verbose
    # $sortedFiles | Join-String -sep ', ' -SingleQuote FullName -op 'Sorted Imports: '
    # | Write-Warning
} catch {
    # Write-Warning "[w] warning: $_"
    Write-Error "[e] Error: $_"
    # $PSCmdlet.ThrowTerminatingError( $_ )
}
# $ErrorActionPreference = 'stop'
# $sortedFiles | Join-String -sep "`n    " -SingleQuote -op "files`n    "
# | Write-Verbose
# | Write-Warning

$sortedFiles
| ForEach-Object {
    $curFile
    $curFile = $_
    Join-String -op "[w] sourcing...`n- '$CurFile'"
    # | Write-Warning
    | Write-Verbose

    $curFile | Join-String -op '[w] CurFile: ' FullName
    | Write-Verbose
    # are these safe? or will it alter where-object?
    # Write-Debug "[dev.nin] importing experiment '$($_.Name)'"
    # try {
    . $curFile
    # } catch {
    $msg = "[e] __init__ => `"$($_.GetType().Name)`""
    # wait-debugger

    # $msg | Write-Warning

    # $PSCmdlet.WriteError( $_ )

    # Write-Error -Message '[ee] bad' _
    # throw '[ee] bad'

    # Write-Error -ea continue -ErrorRecord $_ -Message "Importing failed on: '$curFile'" -

    #-ErrorRecord $_ -Category InvalidResult -ErrorId 'AutoImportModuleFailed' -TargetObject $curFile
    # Write-Error -ea continue -Message "Importing failed on: '$curFile'" -ErrorRecord $_ -Category InvalidResult -ErrorId 'AutoImportModuleFailed' -TargetObject $curFile
    # $PSCmdlet.WriteError( $_ )
    # }
}



$experimentToExport | Join-String -op 'ExperimentToExport' | Write-Verbose

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

$experimentToExport.update_typeDataScriptBlock | ForEach-Object {
    $curSB = $_
    Write-Verbose 'Loading TypeData'
    try {
        . $curSB
    } catch {
        Write-Error -ea continue -Message 'LoadingTypeData Scriptblock failed' -Category InvalidResult
    }
}


# }
#

# rename self to __init__.ps1 for my brain?

# eaiser to manage and filter, especially a dynamic set, in one place
[hashtable]$script:PSRL_experimentToExport = @{
    'function'                   = @()
    'alias'                      = @()
    'cmdlet'                     = @()
    'variable'                   = @()
    'meta'                       = @()
    'update_typeDataScriptBlock' = @()
    'experimentFuncMetadata'     = @()
    'PSReadLineKeyHandler'       = @()
    # 'formatData' = @()
}
$ErrorActionPreference = 'stop'
# & {

# try {
# Don't dot tests, don't call self.
$filteredFiles = Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot) -filter '*.ps1'
| Where-Object { $_.Name -ne '__init__.ps1' }
| Where-Object {
    # are these safe? or will it alter where-object?
    # Write-Debug "removing test: '$($_.Name)'"
    $_.Name -notmatch '\.tests\.ps1$' -and
    $_.Name -notmatch '\.disabled\.ps1$' -and
    $_.Name -match '\.ps1$'
}
$filteredFiles
| Join-String -sep ', ' -SingleQuote FullName -op 'Filtered Imports: '
| Write-Debug
# } catch {
# $PSCmdlet.ThrowTerminatingError( $_ ) # todo: Maybe remove this
# }

$sortedFiles
| ForEach-Object {
    $curFile
    $curFile = $_

    $curFile | Join-String -op 'CurFile: ' FullName
    | Write-Debug
    . $curFile

}


$PSRL_experimentToExport | Join-String -op 'PSRL_ExperimentToExport' | Write-Debug

if ($PSRL_experimentToExport['function']) {
    Export-ModuleMember -Function $PSRL_experimentToExport['function']
}
if ($PSRL_experimentToExport['alias']) {
    Export-ModuleMember -Alias $PSRL_experimentToExport['alias']
}
if ($PSRL_experimentToExport['cmdlet']) {
    Export-ModuleMember -Cmdlet $PSRL_experimentToExport['cmdlet']
}
if ($PSRL_experimentToExport['variable']) {
    Export-ModuleMember -Variable $PSRL_experimentToExport['variable']
}

$PSRL_experimentToExport.update_typeDataScriptBlock | ForEach-Object {
    $curSB = $_
    Write-Verbose 'Loading TypeData'
    try {
        . $curSB
    } catch {
        Write-Error -ea continue -Message 'LoadingTypeData Scriptblock failed' -Category InvalidResult
    }
}

$PSRL_experimentToExport.PSReadLineKeyHandler | ForEach-Object {
    throw 'this never getrs invoked'
    $curSB = $_
    Write-Verbose 'Loading PSReadlineKeyHandler'
    try {
        . $curSB
    } catch {
        Write-Error -ea continue -Message 'PSReadlineKeyHandler Scriptblock failed' -Category InvalidResult
    }
    throw 'Did I reach?'
}

$PSRL_experimentToExport.meta | Format-Table | Write-Information

# }
#

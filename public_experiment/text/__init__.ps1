# rename self to __init__.ps1 for my brain
# re-use logic from below: "../__init__.ps1"

# rename self to __init__.ps1 for my brain?

# eaiser to manage and filter, especially a dynamic set, in one place
# Warning: this isn't loaading
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


# refactor to use:
# class DevNinExperimentalExport {
Write-Warning "Finish re-write '$PSCommandPath' of DevNinExperimentalExport"
# $ErrorActionPreference = 'stop'



# & {

# try {
# Don't dot tests, don't call self.
$filteredFiles = Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot) -Filter '*.ps1'
| Where-Object { $_.Name -ne '__init__.ps1' }
| Where-Object {
    # are these safe? or will it alter where-object?
    # Write-Debug "removing test: '$($_.Name)'"
    $_.Name -notmatch '\.tests\.ps1$'
}
$filteredFiles
| Join-String -sep ', ' -SingleQuote FullName -op 'Filtered Imports: '
| Write-Debug

# Wait-Debugger
$sortedFiles = $filteredFiles | Sort-Object { @('Write-TextColor') -contains $_.BaseName } -Descending
$sortedFiles | Join-String -sep ', ' -SingleQuote FullName -op 'Sorted Imports: '
| Write-Debug
# } catch {
# Write-Warning "warning: $_"
# Write-Error "Error: $_"
# $PSCmdlet.ThrowTerminatingError( $_ )
# }

$sortedFiles
| ForEach-Object {
    $curFile
    $curFile = $_

    $curFile | Join-String -op 'CurFile: ' FullName
    | Write-Debug
    # are these safe? or will it alter where-object?
    # Write-Debug "[dev.nin] importing experiment '$($_.Name)'"
    # try {
    . $curFile
    # } catch {
    # Write-Error -Message 'bad' -ErrorRecord $_
    # Write-Error -ea continue -ErrorRecord $_ -Message "Importing failed on: '$curFile'" -

    #-ErrorRecord $_ -Category InvalidResult -ErrorId 'AutoImportModuleFailed' -TargetObject $curFile
    # Write-Error -ea continue -Message "Importing failed on: '$curFile'" -ErrorRecord $_ -Category InvalidResult -ErrorId 'AutoImportModuleFailed' -TargetObject $curFile
    # $PSCmdlet.WriteError( $_ )
    # }
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

$experimentToExport.update_typeDataScriptBlock | ForEach-Object {
    $curSB = $_
    Write-Verbose 'Loading TypeData'
    try {
        . $curSB
    } catch {
        Write-Error -ea continue -Message 'LoadingTypeData Scriptblock failed' -Category InvalidResult
    }
}

$experimentToExport.meta | Write-Information

# }
#

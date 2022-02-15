


if (!( $null -eq $script:experimentToExport)) {
    Write-Warning 'Already exists!🦎'
    throw 'Already exists!🦎'
}
# eaiser to manage and filter, especially a dynamic set, in one place
# this was the only one that didn't use optional
[hashtable]$script:experimentToExport = @{
    'function'                   = @()
    'alias'                      = @()
    'cmdlet'                     = @()
    'variable'                   = @()
    'meta'                       = @()
    'update_typeDataScriptBlock' = @()
    'experimentFuncMetadata'     = @()
    # 'formatData' = @()
}

try {
    . (Join-Path $PSScriptRoot '__init__.first.ps1')

    # Don't dot tests, don't call self.
    $filteredFiles = Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot) -Filter '*.ps1'
    | Where-Object { $_.Name -ne '__init__.ps1' }
    | Where-Object { $_.Name -ne '__init__.first.ps1' }
    | Where-Object {
        # are these safe? or will it alter where-object?
        # Write-Debug "removing test: '$($_.Name)'"
        $_.Name -notmatch '\.tests\.ps1$' -and
        $_.Name -match '\.ps1$'
    }
    $filteredFiles
    | Join-String -sep ', ' -SingleQuote FullName -op 'Filtered Imports: '
    | Write-Debug

    $sortedFiles = $filteredFiles | Sort-Object {
        @('Write-TextColor') -contains $_.BaseName
    } -Descending

    $sortedFiles | Join-String -sep ', ' -SingleQuote FullName -op 'Sorted Imports: '
    | Write-Debug




} catch {
    throw "'$PSCommandPath' => '$_'"
    # Write-Warning "Exception: $_"
    # Write-Warning "Exception: $_"
    # $PSCmdlet.ThrowTerminatingError( $_ ) # todo: Maybe remove this
}

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
    # }
    # catch {
    # Write-Error -Message "__init__ module '$CurFile' failed!" -ErrorRecord $_
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
        Write-Warning "Exception: $_"
        Write-Error -ea continue -Message 'LoadingTypeData Scriptblock failed' -Category InvalidResult
    }
}

$experimentToExport.meta | Write-Information

# }
#

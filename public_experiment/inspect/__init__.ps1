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
# $ErrorActionPreference = 'stop'
# & {

# try {
if ($true) {
    <#
        # todo: unify import
        Find all *.ps1
        exclude special: '__init__' styl
        exclude *.tests.ps1
    #>
    # Find-ItemsToAutoload -BasePath 'C:\Users\cppmo_000\SkyDrive\Documents\2021\Powershell\My_Github\Dev.Nin\public_experiment'
    "1] Validate all functions are being loaded; `n2] find->replace on all '__init__.ps1' files '$PSCommandPath'"
    | write-color 'magenta' | Write-Warning

    $filteredFiles = Find-ItemsToAutoload -BasePath $PSScriptRoot
    # | Sort-Object { @('Write-TextColor') -contains $_.BaseName } -Descending
    # modify load order
    $sortedFiles = $filteredFiles
    | Sort-Object { @('Write-TextColor') -contains $_.BaseName } -Descending

    if ($true) {

        $filteredFiles
        | ForEach-Object {
            $curScript = $_
            . $curScript
        }


        # if ($false) {

        # # Don't dot tests, don't call self.
        # $filteredFiles = Get-ChildItem -File -Path (Get-Item -ea stop $PSScriptRoot) -Filter '*.ps1'
        # | Where-Object { $_.Name -ne '__init__.ps1' }
        # | Where-Object { $_.Name -notmatch '\.tests\.ps1$' }

        # $filteredFiles
        # | Join-String -sep ', ' -SingleQuote FullName -op 'Filtered Imports: '
        # | Write-Debug

        # $sortedFiles = $filteredFiles
        # | Sort-Object { @('Write-TextColor') -contains $_.BaseName } -Descending
        # $sortedFiles | Join-String -sep "`n  - " -op "SortedImports = [`n" -SingleQuote FullName -os "]`n`n"
        # | Write-Debug
        # } catch {
        # Write-Warning "warning: $_"
        # Write-Error "Error: $_"
        # $PSCmdlet.ThrowTerminatingError( $_ )
        # }
    } else {


        $sortedFiles
        | ForEach-Object {
            $curFile
            $curFile = $_

            $curFile | Join-String -op 'CurFile: ' FullName
            | Write-Debug
            # are these safe? or will it alter where-object?
            # Write-Debug "[dev.nin] importing experiment '$($_.Name)'"
            try {
                . $curFile
            } catch {
                # Write-Error -Message 'bad' -ErrorRecord $_
                # Write-Error -ea continue -ErrorRecord $_ -Message "Importing failed on: '$curFile'" -

                #-ErrorRecord $_ -Category InvalidResult -ErrorId 'AutoImportModuleFailed' -TargetObject $curFile
                # Write-Error -ea continue -Message "Importing failed on: '$curFile'" -ErrorRecord $_ -Category InvalidResult -ErrorId 'AutoImportModuleFailed' -TargetObject $curFile
                $PSCmdlet.WriteError( $_ )
            }
        }

    }
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
    # try {
    . $curSB
    # } catch {
    # Write-Error -ea continue -Message 'LoadingTypeData Scriptblock failed' -Category InvalidResult
    # }
}

$experimentToExport.meta | Write-Information

# }
#

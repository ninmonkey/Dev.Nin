$formatData = @(
)

foreach ($typeName in $formatData) {
    $FileName = ("{0}\public\FormatData\nin-{1}.ps1xml" -f $psscriptroot, $typeName)
    if (Test-Path $FileName ) {
        Update-FormatData -PrependPath $FileName
        Write-Verbose "Imported: FormatData: [$TypeName] $FileName"
    } else {
        Write-Error "Import: failed: FormatData: [$TypeName]  $FileName"
    }
}

$private = @(

)

foreach ($file in $private) {
    if (Test-Path ("{0}\private\{1}.ps1" -f $psscriptroot, $file)) {
    } else {
        Write-Error "Import: failed: private: $File"
    }
    . ("{0}\private\{1}.ps1" -f $psscriptroot, $file)
}

$public_NativeWrapper = @(

)
foreach ($file in $public_NativeWrapper) {
    if (Test-Path ("{0}\public\native_wrapper\{1}.ps1" -f $psscriptroot, $file)) {
    } else {
        Write-Error "Import: failed: public\native_wrapper: $File"
    }
    . ("{0}\public\native_wrapper\{1}.ps1" -f $psscriptroot, $file)

}

Export-ModuleMember -Function $public_NativeWrapper

$completer = @(

)

foreach ($file in $completer) {
    if (Test-Path ("{0}\public\completer\{1}.ps1" -f $psscriptroot, $file)) {
    } else {
        Write-Error "Import: failed: completer: $File"
    }
    . ("{0}\public\completer\{1}.ps1" -f $psscriptroot, $file)
}

Export-ModuleMember -Function $completer

$public = @(
    'Dev-PrintTableTemplate'
    'Dev-FormatTabExpansionResult'
)

foreach ($file in $public) {
    if (Test-Path ("{0}\public\{1}.ps1" -f $psscriptroot, $file)) {
    } else {
        Write-Error "Import: failed: public: $File"
    }
    . ("{0}\public\{1}.ps1" -f $psscriptroot, $file)
}

$functionsToExport = @(
    'Dev-PrintTableTemplate'
    'Dev-FormatTabExpansionResult'
)
Export-ModuleMember -Function $functionsToExport

if ($true) {

    # New-Alias -ea 'Ignore' 'Docs' -Value 'Get-Docs' -Description 'Jump to docs by language'
    $aliasesToExport = @(
        'Table'
    )

    Export-ModuleMember -Alias $aliasesToExport
}
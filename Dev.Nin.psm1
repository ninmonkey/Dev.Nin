$__Config = @{
    Enable_FormatData         = $true
    Enable_FormatData_BuiltIn = $true # toggles overriting builtin type's formatdata
}
$formatData = @(
)

$formatData_BuiltIn = @(
    'FileListing'
)

if ($__Config.Enable_FormatData_BuiltIn) {
    foreach ($typeName in $formatData_BuiltIn) {
        $FileName = ("{0}\public\FormatData\builtin_types\{1}.format.ps1xml" -f $PSScriptRoot, $typeName) | Get-Item -ea stop
        Write-Verbose "Loading NativeFormatData: <$FileName>"
        Update-FormatData -PrependPath $FileName
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
    'Compare-StrictEqual'
    'Get-FunctionDebugInfo'
    'Get-HelpFromType'
    'Get-SavedList'
    'Get-SavedData'
    'Get-DevInspectObject'
    'Get-DevParameterInfo'

    'Dev-PrintTableTemplate'
    'Dev-GetManPage'
    'Dev-GetNameFrom'
    'Dev-GetNamedPath'
    'Dev-FormatTabExpansionResult'
    'Dev-GetNewestItem'
    'Import-NinModule'
    'Get-Exponentiation'
    'Edit-FunctionSource'
    'Start-DevTimer'
    'Get-RegexHelp'
    'Restart-LGHubDriver'
    'Get-DevFunctionInfo'

    # newest experiments
    'Sort-NinObject'
    'Edit-DevTodoList'
    'Find-VerbPrefix'
    'Dev-InvokeFdFind'
    'Out-ConsoleHighlight'
    'import-Dev-Unicode'
    'Format-TemplateString'
    'Dev-ExportFormatData'
    'Get-DevSavedColor'
    'Format-DevColor'

    'Dev-GetDotnetPwshVersion'
)

$public_ToRefactorOutside = @(
    'Restart-LGHubDriver'
)

$functionsToExport += $public_ToRefactorOutside

foreach ($file in $public) {
    $ExpectedPath = Get-Item -ea stop ("{0}\public\{1}.ps1" -f $psscriptroot, $file)
    if (Test-Path $ExpectedPath) {
    } else {
        Write-Error "Import: failed: public: $File"
    }
    . $ExpectedPath
}

$functionsToExport = @(
    'Compare-StrictEqual'
    'Get-HelpFromType'
    'Get-DevInspectObject'

    'Dev-PrintTableTemplate'
    'Dev-GetNewestItem'

    'Dev-GetNameFrom'
    'Dev-GetManPage'
    'Dev-GetNamedPath'
    'Dev-FormatTabExpansionResult'
    'Import-NinModule'
    'Get-Exponentiation'
    'Get-FunctionDebugInfo'
    'Edit-FunctionSource'
    'Get-RegexHelp'
    'Restart-LGHubDriver'
    'Get-DevFunctionInfo'

    # newest experiments
    'Sort-NinObject'
    'Edit-DevTodoList'
    'Get-SavedList'
    'Get-SavedData'
    'Find-VerbPrefix'
    'Dev-InvokeFdFind'
    'Out-ConsoleHighlight'
    'Format-TemplateString'
    'Dev-ExportFormatData'
    'Start-DevTimer'
    'Get-DevSavedColor'
    'Format-DevColor'

    # very temp funcs, to be removed
    '_get-UnicodeHelp'
    'Get-DevParameterInfo'

    'Dev-GetDotnetPwshVersion'
)

$functionsToExport_ToRefactorOutside = @(
    'Restart-LGHubDriver'
)
$functionsToExport += $functionsToExport_ToRefactorOutside
Export-ModuleMember -Function $functionsToExport


# New-Alias -ea 'Ignore' 'Docs' -Value 'Get-Docs' -Description 'Jump to docs by language'
$aliasesToExport = @(
    'TypeHelp'
    'Inspect'
    'HelpFromType'
    'NameFrom'
    'Table'
    'Pow'
    'Man'
    'nMan'
    'ParamInfo'

    # newest experiments
    'Edit-TodoList'
    'Hi'
    'LsFd'
)
Export-ModuleMember -Alias $aliasesToExport

<#
Sketch: Detect imports
if ($False) {
    try {
        # is it imported? otherwise skip
        ( Get-Command label | ForEach-Object CommandType ) -eq 'Alias'
    } catch {
        Import-Module Ninmonkey.Console -Force
    }
    $InformationPreference = 'Continue'
    Write-Warning 'this really should be refactored'
    if ($true -or $ShowExportMapping) {
        Label 'Exported Aliases' '(WIP Debug screen)' -fg red
        | Write-Informationpow
        "to add: 'formatdata', 'private', 'public_nativeWrapper', 'completer', 'public', 'functionsToExport', 'aliasesToExport'"
        | Write-Information
        $aliasesToExport | ForEach-Object {
            $curAlias = $_
            $curCommand = Get-Alias $curAlias | ForEach-Object ResolvedCommand | ForEach-Object Name
            $labelSplat = @{
                Label = $curAlias
                Text  = $curCommand
            }
            Label @labelSplat
        } | Write-Information -Tags 'ModuleDebug'


        Label '## Exported Aliases' '(WIP Debug screen)' -fg red
        | Write-Information

        $public
        | Sort-Object -Unique
        | Join-String -sep "`n" #', '
        | Label '$Public'
        | Write-Information

    }
}
#>

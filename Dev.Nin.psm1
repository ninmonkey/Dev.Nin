﻿$__Config = @{
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
        $FileName = ('{0}\public\FormatData\builtin_types\{1}.format.ps1xml' -f $PSScriptRoot, $typeName) | Get-Item -ea stop
        Write-Verbose "Loading NativeFormatData: <$FileName>"
        Update-FormatData -PrependPath $FileName
    }
}

$private = @(
    # actually private
    '_format_color'

    # quick experiments
    '_dig'
    '_mini_experiment'
    '_test_encodedecode'
    '_Lsd'
    '_JoinStr'
)

foreach ($file in $private) {
    if (Test-Path ('{0}\private\{1}.ps1' -f $psscriptroot, $file)) {
        . ('{0}\private\{1}.ps1' -f $psscriptroot, $file)
    }
    else {
        Write-Error "Import: failed: private: $File"
    }
}

$public_QuickExperiment = @(
    '_get_commandMine'
    'testEncode'
    'testDecode'
    'Lsd'
    'JoinStr'
    'Find-DevItem'
)
Export-ModuleMember -Function $public_QuickExperiment


$public_NativeWrapper = @(

)
foreach ($file in $public_NativeWrapper) {
    if (Test-Path ('{0}\public\native_wrapper\{1}.ps1' -f $psscriptroot, $file)) {
        . ('{0}\public\native_wrapper\{1}.ps1' -f $psscriptroot, $file)
    }
    else {
        Write-Error "Import: failed: public\native_wrapper: $File"
    }

}

Export-ModuleMember -Function $public_NativeWrapper

$completer = @(

)

foreach ($file in $completer) {
    if (Test-Path ('{0}\public\completer\{1}.ps1' -f $psscriptroot, $file)) {
        . ('{0}\public\completer\{1}.ps1' -f $psscriptroot, $file)
    }
    else {
        Write-Error "Import: failed: completer: $File"
    }
}

Export-ModuleMember -Function $completer

$public = @(
    # new
    'Resolve-FullTypeName'
    'ConvertFrom-GistList'

    # ...
    'Compare-StrictEqual'
    'Get-FunctionDebugInfo'
    'Get-HelpFromType'
    'Get-SavedList'
    'Get-SavedData'
    'Get-DevInspectObject'
    'Get-DevParameterInfo'
    'Format-DevParameterInfo'

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
    'New-RegexToggleSensitive'
    'Invoke-EverythingSearch'
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

    'Get-DevRandNumericWord'

    'Dev-GetDotnetPwshVersion'
)

$public_ToRefactorOutside = @(
    'Restart-LGHubDriver'
)

$functionsToExport += $public_ToRefactorOutside

foreach ($file in $public) {
    $ExpectedPath = Get-Item -ea stop ('{0}\public\{1}.ps1' -f $psscriptroot, $file)
    if (Test-Path $ExpectedPath) {
        . $ExpectedPath
    }
    else {
        Write-Error "Import: failed: public: $File"
    }
}

$functionsToExport = @(
    ##  newer
    'Resolve-FullTypeName'
    'ConvertFrom-GistList'

    ## temp imports, to be removed
    '_format_RgbColorString'
    '_format_HslColorString'

    ## main
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
    'New-RegexToggleSensitive'
    'Invoke-EverythingSearch'
    'New-EverythingSearchTerm'
    'Sort-NinObject'

    # more

    'Edit-DevTodoList'
    'Dev-InvokeFdFind'
    'Get-SavedList'
    'Get-SavedData'
    'Find-VerbPrefix'
    'Out-ConsoleHighlight'
    'Format-TemplateString'
    'Dev-ExportFormatData'
    'Start-DevTimer'
    'Get-DevSavedColor'
    'Format-DevColor'
    'Get-DevRandNumericWord'

    # very temp funcs, to be removed
    '_get-UnicodeHelp'
    'Get-DevParameterInfo'
    'Format-DevParameterInfo'

    'Dev-GetDotnetPwshVersion'
)

$functionsToExport_ToRefactorOutside = @(
    'Restart-LGHubDriver'
)
$functionsToExport += $functionsToExport_ToRefactorOutside
Export-ModuleMember -Function $functionsToExport


# New-Alias -ea 'Ignore' 'Docs' -Value 'Get-Docs' -Description 'Jump to docs by language'
$aliasesToExport = @(
    # temporary aliases
    '_randWord'

    ## Section: Regex
    # New-RegexToggleSensitive
    'RegexSensitive'

    # Find-DevItem
    'Dig'
    'Find-Item'

    # Everything Search
    'SearchEvery'
    'eSearch'


    ## Section: Types
    'FullName' # Resolve-FullTypeName
    'TypeHelp'
    'Inspect'
    'HelpFromType'
    'NameFrom'

    ## Other
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
        "to add: 'formatdata', '4te', 'public_nativeWrapper', 'completer', 'public', 'functionsToExport', 'aliasesToExport'"
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

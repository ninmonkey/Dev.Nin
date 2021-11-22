New-Alias 'Join-hashTable' -Value 'Ninmonkey.Console\Join-Hashtable' -Description 'to prevent PSScriptTools\Join-Hashtable' -ea ignore

function __yell {
    <#
    .synopsis
        quick hack, not for use
    #>
    param(
        [string]$Message
    )
    @(
        "`n---------------------`n"
        '.' * 120 | Join-String -op '  error'
        $Message ?? '...'
        "`n---------------------`n"
    ) | Join-String -sep "`n" | Write-Error -ea continue
}

# __yell 0

$__Config = @{
    Enable_FormatData                   = $true
    Enable_FormatData_BuiltIn           = $true # toggles overriting builtin type's formatdata
    Enable_Import_PublicExperiment_Dir  = $True
    Enable_Import_PrivateExperiment_Dir = $True
    Enable_PSReadLineScripts            = $True
}
$formatData = @(
)


# write-debug ('.' * 120 | Join-string -op '  debug')
# write-warning ('.' * 120 | Join-string -op '  warn')
# write-error ('.' * 120 | Join-string -op '  error')


$formatData_BuiltIn = @(
    'FileListing'
)

# __yell a

if ($__Config.Enable_FormatData_BuiltIn) {
    foreach ($typeName in $formatData_BuiltIn) {
        $FileName = ('{0}\public\FormatData\builtin_types\{1}.format.ps1xml' -f $PSScriptRoot, $typeName) | Get-Item -ea stop
        Write-Verbose "Loading NativeFormatData: <$FileName>"
        Update-FormatData -PrependPath $FileName
    }
}


# __yell b

$private = @(
    # actually private
    '_format_color'

    # quick experiments
    '_dig'
    '_mini_experiment'
    '_test_encodedecode'
    '_Lsd'

    # '_toastTimer'
    '_getSpecialAndEnv'
)

foreach ($file in $private) {
    if (Test-Path ('{0}\private\{1}.ps1' -f $psscriptroot, $file)) {
        . ('{0}\private\{1}.ps1' -f $psscriptroot, $file)
    } else {
        Write-Error "Import: failed: private: $File"
    }
}

# __yell C


$public_QuickExperiment = @(
    # '_toastTimer'
    '_get_commandMine'
    'testEncode'
    'testDecode'
    'Lsd'

    'Find-DevItem'
    # special folders?
    'Get-NinEnvInfo'
    'Get-SpecialEnv'
    'Get-SpecialFolder'
)
Export-ModuleMember -Function $public_QuickExperiment


# __yell D


$public_NativeWrapper = @(

)
foreach ($file in $public_NativeWrapper) {
    if (Test-Path ('{0}\public\native_wrapper\{1}.ps1' -f $psscriptroot, $file)) {
        . ('{0}\public\native_wrapper\{1}.ps1' -f $psscriptroot, $file)
    } else {
        Write-Error "Import: failed: public\native_wrapper: $File"
    }

}

Export-ModuleMember -Function $public_NativeWrapper

$completer = @(

)
# __yell E

foreach ($file in $completer) {
    if (Test-Path ('{0}\public\completer\{1}.ps1' -f @($psscriptroot, $file))) {
        . ('{0}\public\completer\{1}.ps1' -f $psscriptroot, $file)
    } else {
        Write-Error "Import: failed: completer: $File"
    }
}

Export-ModuleMember -Function $completer

$public = @(
    # new
    'Resolve-FullTypeName'
    'ConvertFrom-GistList'
    'ConvertFrom-LiteralPath'


    # ...
    'Compare-StrictEqual'
    'Get-FunctionDebugInfo'

    'Get-SavedList'
    'Get-SavedData'
    
    'Get-DevParameterInfo'
    'Format-DevParameterInfo'

    'Dev-PrintTableTemplate'
    'Dev-GetManPage'
    'Dev-GetNameFrom'
    'Dev-GetNamedPath'
    'Dev-FormatTabExpansionResult'
    'Dev-GetNewestItem'

    'Get-Exponentiation'
    'Edit-FunctionSource'
    'Start-DevTimer'
    'Get-RegexHelp'

    # newest experiments
    'New-RegexToggleSensitive'

    'Sort-NinObject'
    'Edit-DevTodoList'
    'Find-VerbPrefix'
    'Dev-InvokeFdFind'
    'Out-ConsoleHighlight'


    'Dev-ExportFormatData'
    'Get-DevSavedColor'
    'Format-DevColor'

    'Get-DevRandNumericWord'

    'Dev-GetDotnetPwshVersion'
)

$public_ToRefactorOutside = @(

)

$functionsToExport += $public_ToRefactorOutside

# __yell G

foreach ($file in $public) {
    Write-Debug "================================= Trying: '$file'"
    $ExpectedPath = Get-Item -ea stop ('{0}\public\{1}.ps1' -f @($psscriptroot, $file))
    if (Test-Path $ExpectedPath) {
        . $ExpectedPath
    } else {
        Write-Error "Import: failed: public: $File"
    }
}
# __yell G2

$functionsToExport = @(
    ##  newer
    'Resolve-FullTypeName'
    'ConvertFrom-GistList'
    'ConvertFrom-LiteralPath'


    ## temp imports, to be removed
    '_format_RgbColorString'
    '_format_HslColorString'

    ## main
    'Compare-StrictEqual'

    

    'Dev-PrintTableTemplate'
    'Dev-GetNewestItem'

    'Dev-GetNameFrom'
    'Dev-GetManPage'
    'Dev-GetNamedPath'
    'Dev-FormatTabExpansionResult'

    'Get-Exponentiation'
    'Get-FunctionDebugInfo'
    'Edit-FunctionSource'
    'Get-RegexHelp'


    # newest experiments
    'New-RegexToggleSensitive'

    'New-EverythingSearchTerm'
    'Sort-NinObject'

    # more

    'Edit-DevTodoList'
    'Dev-InvokeFdFind'
    'Get-SavedList'
    'Get-SavedData'
    'Find-VerbPrefix'
    'Out-ConsoleHighlight'

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

)
$functionsToExport += $functionsToExport_ToRefactorOutside
Export-ModuleMember -Function $functionsToExport


# __yell H
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
    'EditFunc' # Edit-FunctionSource
    'Table'
    'Pow'
    'Man'
    'nMan'
    'ParamInfo'
    'SelectProp' # Select-ObjectProperty
    'PathTovars'  # ConvertFrom-LiteralPath
    # 'Alarm' # _toastTimer

    # newest experiments
    'Edit-TodoList'
    'Hi'
    'LsFd'


)
Export-ModuleMember -Alias $aliasesToExport

# __yell J
. (Get-Item -ea Stop (Join-Path $PSScriptRoot 'public_stable\__init__.ps1'))


if ($__Config.Enable_Import_PrivateExperiment_Dir) {
    . (Get-Item -ea Stop (Join-Path $PSScriptRoot 'private_experiment\__init__.ps1'))
}
if ($__Config.Enable_Import_PublicExperiment_Dir) {
    if ($false -and 'Static subdir list' ) {
        . (Get-Item -ea Stop (Join-Path $PSScriptRoot 'public_experiment\__init__.ps1'))
        . (Get-Item -ea Stop (Join-Path $PSScriptRoot 'public_experiment\git\__init__.ps1'))
    } else {
        # Wait-Debugger
        # $subdirs = Get-ChildItem (Join-Path $b 'public_experiment') -Directory | ForEach-Object FullName
        $subdirs = Get-ChildItem (Join-Path $PSScriptRoot 'public_experiment') -Directory | ForEach-Object FullName
        $initFiles = $subdirs | ForEach-Object { 
            Get-ChildItem $_ -Filter '__init__.ps1'
        } #| ForEach-Object fullname
        $initFiles | ForEach-Object {
            Write-Debug "Loading subdir init: '$_'"
            . $_
        }
    }
}
if ($__Config.Enable_PSReadLineScripts) {
    . (Get-Item -ea Stop (Join-Path $PSScriptRoot 'public_psreadline\__init__.ps1'))
}


# __yell I
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

New-Alias 'Join-hashTable' -Value 'Ninmonkey.Console\Join-Hashtable' -Description 'to prevent PSScriptTools\Join-Hashtable' -ea ignore

__countDuplicateLoad -key 'Dev.Nin.psm1'

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

. (Get-Item -ea stop (Join-Path $PSScriptRoot 'private/before_everything.ps1' ))

# write-debug ('.' * 120 | Join-string -op '  debug')
# write-warning ('.' * 120 | Join-string -op '  warn')
# write-error ('.' * 120 | Join-string -op '  error')


function Find-ItemsToAutoload {
    <#
    .synopsis
        unify autoloading import logic
    .description
        Find all *.ps1
        exclude special: '__init__' styl
        exclude *.tests.ps1
    .notes
        todo: test whether $PSScriptRoot returns the
            path of the file invoking this function
            or the path of this function, which was invoked?
    #>
    param(
        # set a path, fallback to PScriptRoot
        [Parameter(Position = 0)]
        $BasePath
    )
    try {
        $BasePath ??= $PSScriptRoot
        $RootDir = Get-Item -ea stop $BasePath

        $getChildItemSplat = @{
            File   = $true
            Path   = Get-Item -ea stop $RootDir
            Filter = '*.ps1'
        }
    } catch {
        Write-Error "PathNotFound: '$BasePath'"
        return
    }

    $RootDir | Write-Debug

    $filteredFiles = Get-ChildItem @getChildItemSplat
    | Where-Object { $_.Name -ne '__init__.ps1' }
    | Where-Object { $_.Name -ne '__init__.first.ps1' }
    | Where-Object { $_.Name -match '\.ps1$' }
    | Where-Object { $_.Name -notmatch '\.tests\.ps1$' }
    | Where-Object {
        $pathSelf = $PSCommandPath | Get-Item
        $_.FullName -ne $pathSelf.FullName
    }

    $filteredFiles
}

Export-ModuleMember -Function 'Find-ItemsToAutoload'

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

    'ConvertFrom-GistList'


    # ...
    'Compare-StrictEqual'


    'Get-SavedList'
    'Get-SavedData'

    'Get-DevParameterInfo'
    'Format-DevParameterInfo'

    'Dev-PrintTableTemplate'
    'Dev-GetManPage'
    'Dev-GetNameFrom'
    'Dev-GetNamedPath'

    'Dev-GetNewestItem'

    'Get-Exponentiation'
    'Edit-FunctionSource'
    'Start-DevTimer'


    # newest experiments
    'New-RegexToggleSensitive'

    'Sort-NinObject'
    'Edit-DevTodoList'
    'Find-VerbPrefix'

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

    'ConvertFrom-GistList'


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


    'Get-Exponentiation'

    'Edit-FunctionSource'



    # newest experiments
    'New-RegexToggleSensitive'

    'New-EverythingSearchTerm'
    'Sort-NinObject'

    # more

    'Edit-DevTodoList'

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
    # 'PathTovars'  ConvertTo-VariablePathh
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
        . (Get-Item -ea Stop (Join-Path $PSScriptRoot 'public_experiment\__init__.ps1'))

        # $subdirs = Get-ChildItem (Join-Path $b 'public_experiment') -Directory | ForEach-Object FullName
        $subdirs = Get-ChildItem (Join-Path $PSScriptRoot 'public_experiment') -Directory | ForEach-Object FullName
        $initFiles = $subdirs | ForEach-Object {
            Get-ChildItem $_ -Filter '__init__.ps1'
        } #| ForEach-Object fullname
        $initFiles | ForEach-Object -ea break {
            Write-Debug "`n    === `n`n`n  Loading subdir init: '$_'"
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

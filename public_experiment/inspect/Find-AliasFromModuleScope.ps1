using namespace Management.Automation

if ( $experimentToExport ) {
    $experimentToExport.function += @(
        'Find-AliasFromModuleScope'

    )
    # $experimentToExport.alias += @(
    #     # 'Find-AliasFromModuleScope'
    #     # 'Find-AliasFromModuleScope'
    # )
}

function Find-AliasFromModuleScope {
    <#
.description
    I was experimenting with a non-ast method I'm What I'm doing is running get-alias as if it were running inside the module instead of my context.

    [1] get-alias at the local scope, which is just the system defaults, for me.
    & ( Import-Module $ModuleName -PassThru) { Get-Alias -Scope 0 }

    [2] Same thing, but use script: scope, (which means module scope in this context)
    Then filter out the locals, getting the important list, .. module scope.
#>
    param(
        [string]$ModuleName
    )
    # throw "finish using ref 'C:\Users\cppmo_000\SkyDrive\Documents\2022\nin.com\Experiments of the week\2022-04\inspecting-finding-aliases\Invoking Module ⁞ inspect aliases from within ┐using local -2022-04-16 202408.ps1'"
    $mapping = @{}
    'pansies', 'ugit' | ForEach-Object {
        $ModuleName = $_
        $namesToIgnore = & ( Import-Module $ModuleName -PassThru) { Get-Alias -Scope 0 }
        $Mapping[$ModuleName] = & ( Import-Module $ModuleName -PassThru) { Get-Alias -Scope 1 | Where-Object { $_.Name -notin $namesToIgnore.Name } }
    }
    return $Mapping
}

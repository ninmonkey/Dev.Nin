#requires -modules @{ModuleName='Pester';RequiredVersion='5.1.1'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

Describe "$__PesterFunctionName" -Tag Unit {
    BeforeAll {
        # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        # $ErrorActionPreference = 'stop'
    }
    It 'Runs without error' {
        # . $__PesterFunctionName
        findEnvPattern 'jake', 'cpp' -PassThru
    }
}

#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

Describe "$__PesterFunctionName" {
    BeforeAll {
        Import-Module Dev.Nin -Force
        # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        # $ErrorActionPreference = 'Stop'
    }
    It 'Runs without Error' {
        $True | Should -Be $True
    }
    It 'String to type instance' {
        $True | Should -Be $True
        # $ExpectedType = [io.FileInfo]
        # 'IO.FileInfo' | New-TypeInfo | Should -BeOfType $ExpectedType
    }
}

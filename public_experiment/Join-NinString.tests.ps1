#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

Describe "$__PesterFunctionName" -Tag Unit {
    BeforeAll {
        Import-Module Dev.Nin -Force
        # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        $ErrorActionPreference = 'Stop'
    }
    It 'Runs without error' {
        # . $__PesterFunctionName -FrmatMode
    }
    It 'Basic' {
        $Sample = 0..3
        $Expected = $sample -join ', '
        $Sample | Join-NinString Csv | Should -Be $Sample

    }
}
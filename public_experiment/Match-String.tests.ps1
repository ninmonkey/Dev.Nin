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
        { 'foo' | . $__PesterFunctionName -Regex 'o' }
        | Should -Not -Throw
    }
    Describe 'Basic Static' {
        BeforeAll {
            $Sample1 = 'a', '3', 'eaf'
        }
        It 'Supports Null' {
            $null | Where-String ''
            $null | Match-String ''
            $null | Should -Be $Null
            $null | Where-Object { $_ -match '' }
        }
        It 'Basic Static' {
            $Res1 = $Sample1 | Where-Object { $_ -match '\d+' }
            $Res1 = $Sample1 | Match-String { '\d+' }
            # 'a', 'd', '3' | Match-String
            $res1 = 'a', '3', 'eaf' | Where-Object { $_ -match '\d+' }
            $res2 = 2
        }

    }
}

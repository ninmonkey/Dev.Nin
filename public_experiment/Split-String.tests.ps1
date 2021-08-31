#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

Describe "$__PesterFunctionName" -Tag Unit {
    BeforeAll {
        Import-Module Dev.Nin -Force
        # throw "Write Dev.Nin\'Split-String'"
        # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        # $ErrorActionPreference = 'Stop'
    }
    It 'Runs without error' {
        { 'a1b' | . $__PesterFunctionName '\d+' }
        | Should -Not -Throw
        # Split-String
        # $false | Should -Be $True -Because 'Write Split-String'
    }
    It 'Direct Compare' {
        $test1 = ('abc-de---39' -split '\-+') | Should -Be ('abc', 'de', 39)
        $test2 = 'abc-de---39' | Split-String '\-+' | Should -Be ('abc', 'de', 39)
        $test1 | Should -Be $Test2 -Because 'equivalent compare'
    }
    It 'basic Baseline' {
        # evaluates: abc,de,39
        ('abc-de---39' -split '\-+')
        | Should -Be @('abc', 'de', '39') -Because 'Manually written baseline'
    }
    It 'basic Pipe' {
        'abc-de---39' | Split-String '\-+'
        | Should -Be @('abc', 'de', '39') -Because 'Manually written baseline'
    }
    It 'Another Test' {
        ('abc-de---39' -split '\-+') -join ','
        ('abc-de---39' -split '\-+') | Should -Be ('abc', 'de', 39)

    }
}

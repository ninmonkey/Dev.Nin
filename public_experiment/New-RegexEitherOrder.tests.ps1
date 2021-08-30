#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

Describe "$__PesterFunctionName" -Tag Unit {
    BeforeAll {
        Import-Module Dev.Nin -Force
        # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        # $ErrorActionPreference = 'stop'
    }
    It 'Runs without error' {
        # . $__PesterFunctionName
        $expected = '(a)|(b)'
        New-RegexEitherOrder 'a' 'b'
    }
    # It 'Preserves Ascii non-control group chars' {
    #     $Sample = "Hi`tWorld"
    #     $Expected = "Hi`u{9}World"
    #     $Sample | ConvertTo-PwshLiteral
    #     | Should -Be $Expected -Because 'Non control chars are kept intact.'
    # }
}

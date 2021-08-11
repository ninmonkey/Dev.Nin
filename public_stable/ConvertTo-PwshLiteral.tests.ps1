#requires -modules @{ModuleName='Pester';RequiredVersion='5.1.1'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

BeforeAll {
    Import-Module Dev.Nin
}

Describe "$__PesterFunctionName" -Tag Unit {
    BeforeAll {
        . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        $ErrorActionPreference = 'stop'
    }
    It 'Runs without error' {
        # . $__PesterFunctionName
        $Sample = '🐒> ${‍} -eq ${‍‍}'
        $Expected = '"`u{1f412}`u{3e}`u{20}`u{24}`u{7b}`u{200d}`u{7d}`u{20}`u{2d}`u{65}`u{71}`u{20}`u{24}`u{7b}`u{200d}`u{200d}`u{7d}"'
        $Sample | ConvertTo-PwshLiteral
        | Should -Be $Expected -Because 'That is the Correct Pwsh Literal string'
    }
    It 'Preserves Ascii non-control group chars' {
        $Sample = "Hi`tWorld"
        $Expected = "Hi`u{9}World"
        $Sample | ConvertTo-PwshLiteral
        | Should -Be $Expected -Because 'Non control chars are kept intact.'
    }
}

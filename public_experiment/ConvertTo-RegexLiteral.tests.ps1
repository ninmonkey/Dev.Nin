#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}
$SCRIPT:__PesterFunctionName = $myinvocation.MyCommand.Name.split('.')[0]

Describe "$__PesterFunctionName" -Tag Unit {
    BeforeAll {
        Import-Module Dev.nin -Force
        # . $(Get-ChildItem -Path $PSScriptRoot/.. -Recurse -Filter "$__PesterFunctionName.ps1")
        # $Mocks = Resolve-Path "$PSScriptRoot/Mocks"
        $ErrorActionPreference = 'Stop'
    }
    It 'Runs without error' {

        . $__PesterFunctionName 'stuff'
    }
    Describe 'Verify Patterns for Dotnet are still valid' {

        It 'Whether Escaped braces match - hardcoded' {
            ('sdjf}dfsd' -match 'sdjf\}dfsd') -and ('sdjf}dfsd' -match 'sdjf}dfsd')
            | Should -Be $True
        }
        It 'Whether Escaped braces match - Convert to Foreach' {
            # $EscapeBasic = $RawInput | $__PesterFunctionName
            $RawInput = 'sdjf}dfsd'
            $EscapeBasic = $RawInput | ConvertTo-RegexLiteral
            $EscapeVS = $RawInput | ConvertTo-RegexLiteral -AsVSCode
            $EscapeRg = $RawInput | ConvertTo-RegexLiteral -AsRipgrepPattern

            ($RawInput -match $EscapeBasic) | Should -Be $True
            ($RawInput -match $EscapeVS) | Should -Be $True
            ($RawInput -match $EscapeRg) | Should -Be $True
            # ('sdjf}dfsd' -match 'sdjf\}dfsd') -and ('sdjf}dfsd' -match 'sdjf}dfsd')
            # | Should -be $True
        }

    }

}

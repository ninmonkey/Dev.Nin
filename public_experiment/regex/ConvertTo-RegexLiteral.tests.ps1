#requires -modules @{ModuleName='Pester';ModuleVersion='5.0.0'}

Describe 'ConvertTo-RegexLiteral' -Tag Unit {
    BeforeAll {
        Import-Module Dev.nin -Force
        $ErrorActionPreference = 'Stop'
    }
    It 'Runs without error' {
        { ConvertTo-RegexLiteral 'stuff', 'other' }
        | Should -Not -Throw
    }
    Describe 'Verify Patterns for Dotnet are still valid' {

        It 'Whether Escaped braces match - hardcoded' {
            ('sdjf}dfsd' -match 'sdjf\}dfsd') -and ('sdjf}dfsd' -match 'sdjf}dfsd')
            | Should -Be $True
        }
        It 'Whether Escaped braces match - Convert to Foreach' {
            # $EscapeBasic = $RawInput | ConvertTo-RegexLiteral
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

#Requires -Version 7

BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'Find-SetMissingValue' {
    BeforeAll {
        $Sample = @{
            a = 'a', 'b', 'c'
            b = 'b', 'c', 'e', 'f'
        }
    }
    It 'Base Case' {
        $result = Dev.Nin\Find-SetMissingValue -left $Sample.A -Right $Sample.B
        $result.Left | Should -BeExactly @('a')
        $result.Right | Should -BeExactly @('e', 'f')
    }
}

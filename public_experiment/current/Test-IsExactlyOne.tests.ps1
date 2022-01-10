BeforeAll {
    Import-Module Dev.Nin -Force
}


Describe 'IsExactlyOne' {
    <#
        2 | Test-IsExactlyOne       | yes


        decide, or add different handlers, because you may want

        3, 2 | Test-IsExactlyOne    | yes, yes
            or
        3, 2 | Test-IsExactlyOne    | no
    #>

    It 'Returns <expected> (<name>)' -ForEach @(
        @{ Name = 'cactus'; Expected = '🌵' }
        @{ Name = 'giraffe'; Expected = '🦒' }
    ) {
        $Expected | Should -Be $expected
    }
    It 'ShouldBeError?' -Pending {
        , @(1, 2) | Test-IsExactlyOne | Should -Be $true -Because 'I think it only emits once?'
    }
    It 'Returns <Expected> (<Value>)' -ForEach @(
        # @{ Name = 'cactus'; Expected = '🌵' }
        @{
            Value    = 1
            Expected = $true
        }
        @{
            Value    = 1, 2
            Expected = $false
        }
        @{
            Value    = , @(1)
            Expected = $true
        }
        @{
            Value    = $null
            Expected = $false
        }
    ) {
        $Expected | Test-IsExactlyOne | Should -Be $expected
    }

    It 'Pipe single <Value> is <Expected>' -ForEach @(
        @{ Value = 'test'; $Expected = 'Test' }
        @{ Value = 'test'; $Expected = $true }
    ) -Pending {
        $Expected | Should -Be $true
    }


}

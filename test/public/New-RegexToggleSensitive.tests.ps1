BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}
Describe 'New-RegexToggleSensitive' {

    It 'Returns <expected> (<pattern>)' -ForEach @(
        @{ pattern = 'FooBar'; expected = '(?-i)FooBar(?i)' }
    ) {
        New-RegexToggleSensitive -Pattern $pattern | Should -Be $expected
    }
}

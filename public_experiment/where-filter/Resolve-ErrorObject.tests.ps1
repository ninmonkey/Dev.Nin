BeforeAll {
    Import-Module Dev.Nin -Force
}

Describe 'Resolve-ErrorObject' {
    It 'expect1' {
        1 / 0
        $err = Resolve->Error
        $err.count | Should -Be 1
    }
    It 'scope error' {
        # _ -scope 5
        # Get-Variable -Scope 99 -Name '*' -ea silentlyContinue
    }
    It 'error record' -Pending -because 'nyi' {
        "Don't assume it's always an exception/error record"
    }
}

BeforeAll {
    Import-Module Dev.nin -Force
}

Describe 'iProp' {
    It 'Returns anything' {
        $ErrorActionPreference = 'stop'
        Get-Date
        | iprop | len
        | Should -Not -Be 0 -ea Break
    }
}

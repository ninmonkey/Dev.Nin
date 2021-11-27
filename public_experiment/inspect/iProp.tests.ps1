BeforeAll {
    Import-Module Dev.nin -Force
}

Describe 'iProp' {
    It 'Returns anything' {
        $ErrorActionPreference = 'break'
        Get-Date
        | iprop | len
        | Should -Not -Be 0 -ea Break        
    }
}
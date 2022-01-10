BeforeAll {
    Import-Module Dev.Nin -Force
    Import-Module Ninmonkey.Console -Force
}

Describe 'Invoke-NinFormatter' {
    It 'Should Not Throw' {
        { 'test' | Invoke-NinFormatter }
        | Should -Not THrow
    }
    It 'based2' {
        $True | Set-ItResult -Pending
    }
}

BeforeAll {
    Import-Module 'Dev.Nin' -Force
}

Describe 'Dev.Join-StringStyle' {
    BeforeAll {
        $ErrorAction = 'Break'
    }
    It 'works?' {
        $true | Should -Be $True
    }
    It 'HardCodedSample' {
        $Expected = 0..3 -join ', '
        0..3 | Dev.Join-StringStyle Csv -ea Break -Debug -wa Continue
        | Should -Be $Expected
    }
}

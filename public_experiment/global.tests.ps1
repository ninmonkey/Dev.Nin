BeforeAll {
}

Describe 'Global.Dev.Nin' {
    It 'Imports Without Error' {
        { Import-Module Dev.Nin -Force -ea stop }
        | Should -Not -Throw
    }
}